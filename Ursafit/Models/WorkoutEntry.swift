//
//  WorkoutEntry.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//
import HealthKit
import Foundation

struct WorkoutEntry: Identifiable {
    let id: UUID
    let title: String
    let date: Date
    let duration: TimeInterval
    let energyBurned: Double?  // in calories
    let distance: Double?      // in kilometers
    let workoutType: HKWorkoutActivityType
    let coinsEarned: Int
    
    var description: String {
        var components: [String] = []
        
        components.append("Duration: \(formattedDuration)")
        
        if let energy = energyBurned {
            components.append("Energy: \(Int(energy)) cals")
        }
        
        if let dist = distance {
            components.append("Distance: \(String(format: "%.2f", dist)) km")
        }
        
        return components.joined(separator: ", ")
    }
    
    private var formattedDuration: String {
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
    
    init(from workout: HKWorkout) {
        self.id = UUID()
        self.date = workout.startDate
        self.duration = workout.duration
        self.workoutType = workout.workoutActivityType
        
        // Extract energy burned
        self.energyBurned = workout.totalEnergyBurned?.doubleValue(for: .smallCalorie())
        
        // Extract distance in kilometers
        if let distanceMeters = workout.totalDistance?.doubleValue(for: .meter()) {
            self.distance = distanceMeters / 1000
        } else {
            self.distance = nil
        }
        
        // Map workout type to title
        self.title = workout.workoutActivityType.displayName
        
        // Calculate coins (example: 10 coins per minute)
        self.coinsEarned = Int(energyBurned ?? 0)
    }

    // For testing/preview purposes
    init(preview: Bool = false) {
        self.id = UUID()
        self.title = "Sample Workout"
        self.date = Date()
        self.duration = 1800 // 30 minutes
        self.energyBurned = 2500
        self.distance = 3.5
        self.workoutType = .running
        self.coinsEarned = 300
    }
}

// Helper extension for workout type names
extension HKWorkoutActivityType {
    var displayName: String {
        switch self {
        case .running: return "Run"
        case .cycling: return "Cycle"
        case .walking: return "Walk"
        case .swimming: return "Swim"
        default: return "Workout"
        }
    }
}
