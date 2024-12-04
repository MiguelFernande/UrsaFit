//
//  UserDatabaseService.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 12/1/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseAuthUI
import FirebaseFirestore

class UserDatabaseService {
    private let db = Firestore.firestore()
    
    func createUserProfile(user: User) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw NSError(domain: "UserNotFound", code: -1)
        }
        
        try await db.collection("users").document(currentUser.uid).setData([
            "name": user.name,
            "username": user.username,
            "currentStreak": user.currentStreak,
            "bearCoins": user.bearCoins,
            "streakFreezes": user.streakFreezes,
            "scheduleType": user.scheduleType.rawValue,
            "workoutDays": Array(user.workoutDays).map { $0.rawValue },
            "weeklyWorkoutCount": user.weeklyWorkoutCount,
            "lastWorkoutDate": user.lastWorkoutDate as Any,
            "amtDonated": user.amtDonated
        ])
    }
    
    func fetchUserProfile(userID: String) async throws -> User {
        let document = try await db.collection("users").document(userID).getDocument()
        guard let data = document.data() else {
            throw NSError(domain: "UserNotFound", code: -1)
        }
        
        return User(
            name: data["name"] as? String ?? "",
            username: data["username"] as? String ?? "",
            currentStreak: data["currentStreak"] as? Int ?? 0,
            bearCoins: data["bearCoins"] as? Int ?? 0,
            streakFreezes: data["streakFreezes"] as? Int ?? 0,
            scheduleType: WorkoutScheduleType(rawValue: data["scheduleType"] as? String ?? "") ?? .loose,
            workoutDays: Set((data["workoutDays"] as? [String] ?? []).compactMap { Weekday(rawValue: $0) }),
            weeklyWorkoutCount: data["weeklyWorkoutCount"] as? Int ?? 3,
            lastWorkoutDate: data["lastWorkoutDate"] as? Date,
            amtDonated: data["amtDonated"] as? Int ?? 0
        )
    }
}
