//
//  HKWorkoutActivityType.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/15/24.
//
import HealthKit

extension HKWorkoutActivityType {
    var icon: String {
        switch self {
        case .running: return "🏃"
        case .cycling: return "🚴"
        case .walking: return "🚶"
        case .swimming: return "🏊"
        default: return "💪"
        }
    }
}
