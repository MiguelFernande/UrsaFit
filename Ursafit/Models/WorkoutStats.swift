//
//  WorkoutStats.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/17/24.
//
import Foundation

struct WorkoutStats {
    var elapsedTime: TimeInterval = 0
    var calories: Double = 0
    var distance: Double = 0
    
    var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var formattedDistance: String {
        String(format: "%.2f km", distance/1000)
    }
    
    mutating func reset() {
        elapsedTime = 0
        calories = 0
        distance = 0
    }
    
    mutating func update(calories: Double, distance: Double) {
        self.calories = calories
        self.distance = distance
    }
}
