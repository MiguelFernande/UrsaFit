//
//  ExerciseDetailView.swift
//  Ursafit
//
//  Created by kiana berchini on 12/1/24.
//
import SwiftUI
struct ExerciseDetailView: View {
    var exercise: Exercise
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(exercise.name)
                    .font(.title)
                    .padding(.bottom, 4)
                Text("Type: \(exercise.type)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if let muscle = exercise.muscle {
                    Text("Muscle: \(muscle)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                if let equipment = exercise.equipment {
                    Text("Equipment: \(equipment)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                if let difficulty = exercise.difficulty {
                    Text("Difficulty: \(difficulty)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Text("Instructions")
                    .font(.title2)
                    .padding(.top, 16)
                Text(exercise.instructions)
                    .font(.body)
                    .padding(.top, 8)
                Spacer()
            }
            .padding()
        }
        .navigationTitle(exercise.name)
    }
}
