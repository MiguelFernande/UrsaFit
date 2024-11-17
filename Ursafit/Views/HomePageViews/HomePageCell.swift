//
//  HomePageCell.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import SwiftUI
import HealthKit

struct HomePageCell: View {
    let workout: WorkoutEntry // Displays workout entry details

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(workout.workoutType.icon) // Ensure workoutType is displayed correctly
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(workout.title)
                        .font(.headline)
                    
                    Text(workout.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            HStack {
                Text("Duration: \(workout.duration / 60, specifier: "%.1f") min")
                Spacer()
                Text("\(workout.energyBurned ?? 0, specifier: "%.0f") cal")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}
