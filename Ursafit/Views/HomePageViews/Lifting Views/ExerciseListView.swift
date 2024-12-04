//
//  ExerciseListView.swift
//  Ursafit
//
//  Created by kiana berchini on 12/1/24.
//
import SwiftUI
struct ExerciseListView: View {
    @ObservedObject var viewModel: ExerciseViewModel
    var body: some View {
        VStack {
            // Search bar for filtering exercises
            SearchBar(text: $viewModel.searchQuery)
                .padding()
            // List of Exercises
            List(viewModel.filteredExercises(), id: \.name) { exercise in
                NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                    Text(exercise.name)
                        .font(.headline)
                }
            }
            .onAppear {
                // Fetch exercises when the view appears
                Task {
                    await viewModel.fetchExercises()
                }
            }
        }
        .navigationTitle("Exercises")
    }
}
