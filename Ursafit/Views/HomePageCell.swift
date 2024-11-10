//
//  Main.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import SwiftUI

struct HomePageCell: View {
    let workout: WorkoutEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // TODO: Add workout icon image
                Text("🏋️‍♂️") // Placeholder for workout type icon
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(workout.title)
                        .font(.headline)
                    Text(workout.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("+\(workout.coinsEarned) 🪙")
                    .font(.callout)
                    .bold()
            }
            
            Text(workout.description)
                .font(.body)
                .lineLimit(2)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// MARK: - Preview
struct HomePageCell_Previews: PreviewProvider {
    static var previews: some View {
        HomePageCell(workout: WorkoutEntry(
            id: UUID(),
            title: "Morning Workout",
            description: "Completed 30 minutes of cardio and strength training",
            date: Date(),
            coinsEarned: 50,
            workoutType: .cardio
        ))
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
