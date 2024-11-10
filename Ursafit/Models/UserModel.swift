//
//  UserModel.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import Foundation
import HealthKit

// Represents different types of workout goals
enum GoalFrequency {
    case daily
    case weekly
    case custom([Weekday])
}

// Represents days of the week for custom goals
enum Weekday: String, CaseIterable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
}

// Main User class to store user data
class User: ObservableObject, Identifiable {
    let id: UUID
    
    @Published var name: String
    @Published var username: String
    @Published var currentStreak: Int
    @Published var bearCoins: Int
    @Published var streakFreezes: Int
    @Published var workoutGoals: [WorkoutGoal]
    @Published var achievements: [Achievement]
    @Published var totalWorkoutsCompleted: Int
    @Published var lastWorkoutDate: Date?
    
    init(
        id: UUID = UUID(),
        name: String,
        username: String,
        currentStreak: Int = 0,
        bearCoins: Int = 0,
        streakFreezes: Int = 0,
        workoutGoals: [WorkoutGoal] = [],
        achievements: [Achievement] = [],
        totalWorkoutsCompleted: Int = 0,
        lastWorkoutDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.currentStreak = currentStreak
        self.bearCoins = bearCoins
        self.streakFreezes = streakFreezes
        self.workoutGoals = workoutGoals
        self.achievements = achievements
        self.totalWorkoutsCompleted = totalWorkoutsCompleted
        self.lastWorkoutDate = lastWorkoutDate
    }
    
    // Supporting struct for workout goals
    struct WorkoutGoal: Identifiable {
        let id: UUID
        var frequency: GoalFrequency
        var isActive: Bool
    }
    
    // Supporting struct for achievements probs not gonna be implemented unless we have tons of time.
    struct Achievement: Identifiable {
        let id: UUID
        var title: String
        var description: String
        var dateEarned: Date
    }
    
}
