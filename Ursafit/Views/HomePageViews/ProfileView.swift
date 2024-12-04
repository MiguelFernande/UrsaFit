//
//  ProfileView.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/16/24.
//

import FirebaseAuth
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var userData: User?
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            List {
                if Auth.auth().currentUser != nil {
                    if isLoading {
                        ProgressView()
                    } else if let user = userData {
                        // Basic Info Section
                        Section(header: Text("Basic Info")) {
                            Text("Name: \(user.name)")
                            Text("Username: \(user.username)")
                        }
                        
                        // Stats Section
                        Section(header: Text("Stats")) {
                            Text("Current Streak: \(user.currentStreak) days")
                            Text("Bear Coins: \(user.bearCoins)")
                            Text("Streak Freezes: \(user.streakFreezes)")
                            Text("Donated to Uncle Larry: \(user.amtDonated) 🪙")
                        }
                        
                        // Workout Schedule Section
                        Section(header: Text("Workout Schedule")) {
                            Text("Schedule Type: \(user.scheduleType.rawValue.capitalized)")
                            
                            // Show different info based on schedule type
                            switch user.scheduleType {
                            case .strict:
                                if !user.workoutDays.isEmpty {
                                    Text("Scheduled Workout Days:")
                                    ForEach(Array(user.workoutDays).sorted { $0.rawValue < $1.rawValue }, id: \.self) { day in
                                        Text("- \(day.rawValue.capitalized)")
                                    }
                                } else {
                                    Text("No workout days set")
                                }
                                
                            case .loose:
                                Text("Weekly Workout Goal: \(user.weeklyWorkoutCount) days")
                            }
                        }
                        
                        // Last Workout Section
                        Section(header: Text("Last Workout")) {
                            if let lastWorkout = user.lastWorkoutDate {
                                Text("Last Workout: \(lastWorkout.formatted())")
                            } else {
                                Text("No workouts recorded")
                            }
                        }
                        
                        // Logout Section
                        Section {
                            Button(action: {
                                do {
                                    try Auth.auth().signOut()
                                    coordinator.navPath.removeAll()
                                } catch {
                                    print("Error signing out: \(error.localizedDescription)")
                                }
                            }) {
                                Text("Log Out")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                } else {
                    Section {
                        Button(action: {
                            coordinator.navPath.append(.auth)
                        }) {
                            Text("Log In / Create Account")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                if Auth.auth().currentUser != nil {
                    fetchUserData()
                }
            }
        }
    }
    
    private func fetchUserData() {
        isLoading = true
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Task {
            do {
                let userDatabaseService = UserDatabaseService()
                let fetchedUser = try await userDatabaseService.fetchUserProfile(userID: userId)
                await MainActor.run {
                    self.userData = fetchedUser
                    self.isLoading = false
                }
            } catch {
                print("Error fetching user data: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }
}
