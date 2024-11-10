//
//  MainViewModel.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//
import SwiftUI

// MARK: - Workout Entry Model
struct WorkoutEntry: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let date: Date
    let coinsEarned: Int
    let workoutType: WorkoutType
    
    enum WorkoutType {
        case strength
        case cardio
        case flexibility
        case custom(String)
        
        // TODO: Add function to get appropriate icon for each type
        /*
        func getIcon() -> String {
            switch self {
                case .strength: return "dumbbell"
                case .cardio: return "heart.circle"
                case .flexibility: return "figure.flexibility"
                case .custom: return "star"
            }
        }
        */
    }
}

// MARK: - View Model
class MainViewModel: ObservableObject {
    @Published var user: User
    @Published var workoutFeed: [WorkoutEntry]
    
    init(user: User) {
        self.user = user
        
        // Sample workout feed data - Replace with real data later
        self.workoutFeed = [
            WorkoutEntry(
                id: UUID(),
                title: "Sample Workout 1",
                description: "This is a placeholder workout entry",
                date: Date(),
                coinsEarned: 50,
                workoutType: .cardio
            ),
            WorkoutEntry(
                id: UUID(),
                title: "Sample Workout 2",
                description: "Another placeholder workout entry",
                date: Date().addingTimeInterval(-3600 * 24),
                coinsEarned: 30,
                workoutType: .strength
            )
        ]
    }
    
    // MARK: - Future Implementation Functions
    
    // TODO: Implement workout tracking
    /*
    func startWorkout() {
        // 1. Create new workout session
        // 2. Start timer
        // 3. Begin HealthKit tracking
        // 4. Update UI state
    }
    */
    
    // TODO: Implement streak calculation
    /*
    func calculateStreak() {
        // 1. Get workout history
        // 2. Check consecutive days
        // 3. Handle streak freezes
        // 4. Update streak count
    }
    */
    
    // TODO: Implement coin management
    /*
    func updateCoins(amount: Int, type: TransactionType) {
        // 1. Validate transaction
        // 2. Update coin balance
        // 3. Save transaction history
        // 4. Update UI
    }
    */
    
    // TODO: Implement feed management
    /*
    func updateFeed() {
        // 1. Fetch recent workouts
        // 2. Sort by date
        // 3. Apply any filters
        // 4. Update feed array
    }
    */
    
    // MARK: - Minimal Implementation for Preview
    
    // Basic function to add a workout - just for testing
    func addWorkout(_ workout: WorkoutEntry) {
        workoutFeed.insert(workout, at: 0)
        // Just increment values for preview purposes
        user.currentStreak += 1
        user.bearCoins += workout.coinsEarned
    }
}

// MARK: - Preview Helper
extension MainViewModel {
    static func previewModel() -> MainViewModel {
        let user = User(
            name: "Preview User",
            username: "preview_user",
            currentStreak: 3,
            bearCoins: 150
        )
        return MainViewModel(user: user)
    }
}
