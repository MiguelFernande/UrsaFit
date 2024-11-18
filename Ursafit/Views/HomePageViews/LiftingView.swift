//
//  WorkoutSearchView.swift
//  Ursafit
//
//  Created by kiana berchini on 11/12/24.
//

import SwiftUI

struct LiftingView: View {
    @StateObject private var viewModel = ExerciseViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading exercises...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(viewModel.exercises) { exercise in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(exercise.name)
                            .font(.headline)
                        Text(exercise.instructions)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Exercises")
        .onAppear {
            viewModel.fetchExercises()
        }
    }
}
