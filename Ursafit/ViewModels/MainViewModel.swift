//
//  MainViewModel.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseFirestore

// MARK: - View Model
class MainViewModel: NSObject, ObservableObject {
    @Published var user: User
    @Published var workoutFeed: [WorkoutEntry]
    @Published var workoutStartTime: Date?
    @Published var isWorkoutActive: Bool = false
    
    @Published var isAuthenticated = false
    @Published var authError: Error?

    let workoutService: WorkoutService
    let permissionService: PermissionService

    init(user: User, workoutService: WorkoutService, permissionService: PermissionService) {
        self.user = user
        self.workoutFeed = []
        self.workoutService = workoutService
        self.permissionService = permissionService
        super.init() // Required for NSObject
        
        // Request HealthKit authorization on init
        Task {
            await requestInitialHealthKitPermissions()
        }
    }
    
    private func requestInitialHealthKitPermissions() async {
        do {
            _ = try await permissionService.requestAuthorization()
            await fetchWorkouts() // Only fetch after authorization
        } catch {
            print("Failed to request HealthKit authorization: \(error)")
        }
    }
    
    
    func checkAuthState() {
        if Auth.auth().currentUser != nil {
            // User is signed in
            self.isAuthenticated = true
            // Load user data from UserDefaults if available
            if let userData = UserDefaults.standard.data(forKey: "userData"),
               let savedUser = try? JSONDecoder().decode(User.self, from: userData) {
                self.user = savedUser
            }
        } else {
            self.isAuthenticated = false
        }
    }
    
    func saveUserToDefaults() {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "userData")
        }
    }
    

    // MARK: - Workout Management
    func startWorkout() async {
        // First check permissions
        let status = permissionService.checkAuthorizationStatus()

        switch status {
        case .notDetermined, .denied:
            // Need to request permissions
            let authorized = try? await permissionService.requestAuthorization()
            guard authorized == true else {
                print("HealthKit authorization failed")
                return
            }
        case .notAvailable:
            print("HealthKit not available")
            return
        case .unknown:
            print("Unknown HealthKit authorization status")
            return
        case .authorized:
            break // Already authorized, continue
        }
        
        // Now start the workout
        do {
            try await workoutService.startWorkout()
            await MainActor.run {
                isWorkoutActive = true
                workoutStartTime = Date()
            }
        } catch {
            print("Error starting workout: \(error.localizedDescription)")
        }
    }

    func endWorkout() async {
        do {
            let workout = try await workoutService.endWorkout()

            await MainActor.run {
                isWorkoutActive = false
                Task {
                    await fetchWorkouts()
                    await calculateStreak()
                    let caloriesBurned = workout.totalEnergyBurned?.doubleValue(for: .smallCalorie()) ?? 0
                    updateCoins(amount: Int(caloriesBurned), type: .workoutCompleted)
                }
            }
        } catch {
            print("Error ending workout: \(error.localizedDescription)")
        }
    }

    // MARK: - Data Management
    func fetchWorkouts() async {
        do {
            let workouts = try await workoutService.fetchRecentWorkouts()
            await MainActor.run {
                self.workoutFeed = workouts
            }
        } catch {
            print("Error fetching workouts: \(error)")
        }
    }

    func calculateStreak() async {
        do {
            let workouts = try await workoutService.fetchRecentWorkouts()
            let currentStreak = computeStreak(from: workouts)
            await MainActor.run { user.currentStreak = currentStreak }
        } catch {
            print("Error calculating streak: \(error)")
        }
    }

    private func computeStreak(from workouts: [WorkoutEntry]) -> Int {
        var currentStreak = 0
        var lastWorkoutDate: Date?

        let sortedWorkouts = workouts.sorted { $0.date > $1.date }

        if let mostRecent = sortedWorkouts.first {
            lastWorkoutDate = Calendar.current.startOfDay(for: mostRecent.date)
            currentStreak = 1

            for i in 1..<sortedWorkouts.count {
                let workoutDate = Calendar.current.startOfDay(for: sortedWorkouts[i].date)
                guard let lastDate = lastWorkoutDate else { break }

                let daysBetween = Calendar.current.dateComponents([.day], from: workoutDate, to: lastDate).day ?? 0

                if daysBetween == 1 {
                    currentStreak += 1
                    lastWorkoutDate = workoutDate
                } else {
                    break
                }
            }
        }

        return currentStreak
    }

    // MARK: - Coin Management
    enum TransactionType {
        case workoutCompleted
        case streakBonus
        case purchase
    }

    func updateCoins(amount: Int, type: TransactionType) {
        switch type {
        case .workoutCompleted, .streakBonus:
            user.bearCoins += amount
        case .purchase:
            guard user.bearCoins >= amount else { return }
            user.bearCoins -= amount
        }
    }
    
    func donateToUncleLarry() -> Bool {
        guard user.bearCoins >= 150 else {
            print("Not enough coins to donate to Uncle Larry!")
            return false
        }
        
        user.bearCoins -= 150 // Deduct 150 coins
        
        // Update database
        Task {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let db = Firestore.firestore()
            
            do {
                try await db.collection("users").document(userId).updateData([
                    "bearCoins": user.bearCoins
                ])
                print("Donated 150 coins to Uncle Larry!")
            } catch {
                print("Error updating coins in database: \(error.localizedDescription)")
                // Rollback the local change if database update fails
                user.bearCoins += 150
                return
            }
        }
        
        return true
    }

    func buyStreakFreeze() -> Bool {
        guard user.bearCoins >= 100 else {
            print("Not enough coins to buy a streak freeze!")
            return false
        }
        
        user.bearCoins -= 100 // Deduct 100 coins
        user.streakFreezes += 1 // Add a streak freeze
        
        // Update database
        Task {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let db = Firestore.firestore()
            
            do {
                try await db.collection("users").document(userId).updateData([
                    "bearCoins": user.bearCoins,
                    "streakFreezes": user.streakFreezes
                ])
                print("Purchased a streak freeze!")
            } catch {
                print("Error updating user data in database: \(error.localizedDescription)")
                // Rollback the local changes if database update fails
                user.bearCoins += 100
                user.streakFreezes -= 1
                return
            }
        }
        
        return true
    }
    
    func updateCoinsInDatabase() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        do {
            try await db.collection("users").document(userId).updateData([
                "bearCoins": user.bearCoins
            ])
        } catch {
            print("Error updating coins in database: \(error.localizedDescription)")
        }
    }
    
}
