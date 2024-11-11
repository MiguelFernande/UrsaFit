//
//  WorkoutEntry.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//
import HealthKit
import Foundation

struct WorkoutEntry: Identifiable {
    var id: UUID
    var title: String
    var description: String
    var date: Date
    var coinsEarned: Int
    
    // HealthKit properties
    var healthKitWorkout: HKWorkout?
    var activeEnergyBurned: Double?
    var distance: Double?
    var duration: TimeInterval?

    // Initializer from HKWorkout
    init(from healthKitWorkout: HKWorkout) {
        self.id = UUID()
        self.title = "Workout" // Can be customized or mapped based on the workout type
        self.date = healthKitWorkout.startDate
        self.coinsEarned = Int(healthKitWorkout.duration / 60) * 10 // Example logic: 10 coins per minute
        
        // Set HealthKit properties
        self.healthKitWorkout = healthKitWorkout
        self.duration = healthKitWorkout.duration

        // Extract additional data from workout metadata
        if let energyBurned = healthKitWorkout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) {
            self.activeEnergyBurned = energyBurned
        }

        if let distance = healthKitWorkout.totalDistance?.doubleValue(for: .meter()) {
            self.distance = distance / 1000 // Convert to kilometers
        }
        
        // Custom description based on extracted data
        self.description = "Duration: \(Int(duration ?? 0) / 60) mins, Energy Burned: \(Int(activeEnergyBurned ?? 0)) kcal, Distance: \(String(format: "%.2f", distance ?? 0)) km"
    }
}
