//
//  UserModel.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import Foundation

// Represents workout scheduling type
enum WorkoutScheduleType: String, Codable {
    case strict = "strict"    // User works out on specific days
    case loose = "loose"     // User works out X times per week
}


// Represents days of the week for strict schedule
enum Weekday: String, CaseIterable, Codable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
}

// Main User class to store user data
class User: ObservableObject, Identifiable, Codable {
    let id: UUID
    
    @Published var name: String
    @Published var username: String
    @Published var currentStreak: Int
    @Published var bearCoins: Int
    @Published var streakFreezes: Int
    @Published var scheduleType: WorkoutScheduleType
    @Published var workoutDays: Set<Weekday>
    @Published var weeklyWorkoutCount: Int
    @Published var lastWorkoutDate: Date?
    @Published var amtDonated: Int
    @Published var weeklyWorkoutsCompleted: Int = 0

    
    // Add CodingKeys for Codable
    enum CodingKeys: String, CodingKey {
        case id, name, username, currentStreak, bearCoins, streakFreezes,
             scheduleType, workoutDays, weeklyWorkoutCount, lastWorkoutDate, amtDonated
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(username, forKey: .username)
        try container.encode(currentStreak, forKey: .currentStreak)
        try container.encode(bearCoins, forKey: .bearCoins)
        try container.encode(streakFreezes, forKey: .streakFreezes)
        try container.encode(scheduleType, forKey: .scheduleType)
        try container.encode(Array(workoutDays), forKey: .workoutDays)
        try container.encode(weeklyWorkoutCount, forKey: .weeklyWorkoutCount)
        try container.encode(lastWorkoutDate, forKey: .lastWorkoutDate)
        try container.encode(amtDonated, forKey: .amtDonated)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        username = try container.decode(String.self, forKey: .username)
        currentStreak = try container.decode(Int.self, forKey: .currentStreak)
        bearCoins = try container.decode(Int.self, forKey: .bearCoins)
        streakFreezes = try container.decode(Int.self, forKey: .streakFreezes)
        scheduleType = try container.decode(WorkoutScheduleType.self, forKey: .scheduleType)
        workoutDays = Set(try container.decode([Weekday].self, forKey: .workoutDays))
        weeklyWorkoutCount = try container.decode(Int.self, forKey: .weeklyWorkoutCount)
        lastWorkoutDate = try container.decodeIfPresent(Date.self, forKey: .lastWorkoutDate)
        amtDonated = try container.decode(Int.self, forKey: .amtDonated)
    }
    
    
    
    init(
            id: UUID = UUID(),
            name: String,
            username: String,
            currentStreak: Int = 0,
            bearCoins: Int = 0,
            streakFreezes: Int = 0,
            scheduleType: WorkoutScheduleType = .loose,
            workoutDays: Set<Weekday> = [],
            weeklyWorkoutCount: Int = 0,
            lastWorkoutDate: Date? = nil,
            amtDonated: Int = 0
        ) {
            self.id = id
            self.name = name
            self.username = username
            self.currentStreak = currentStreak
            self.bearCoins = bearCoins
            self.streakFreezes = streakFreezes
            self.scheduleType = scheduleType
            self.workoutDays = workoutDays
            self.weeklyWorkoutCount = weeklyWorkoutCount
            self.lastWorkoutDate = lastWorkoutDate
            self.amtDonated = amtDonated
        }
}
