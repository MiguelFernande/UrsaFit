//
//  HomePage.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 10/28/24.
//

import SwiftUI

struct HomePage: View {
    @EnvironmentObject var viewModel: MainViewModel
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack {
                    // Top Navigation Bar
                    HomeNavBar()
                    
                    if coordinator.isWorkoutPromptVisible {
                        WorkoutPrompt(isShowing: $coordinator.isWorkoutPromptVisible)
                            .environmentObject(coordinator)
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(viewModel.workoutFeed) { workout in
                                    HomePageCell(workout: workout)
                                }
                            }
                        }
                    }

                    // Ribbon Section
                    HomePageRibbon(
                        showingWorkoutPrompt: $coordinator.isWorkoutPromptVisible
                    )
                    .environmentObject(coordinator)
                }
            }
        }
    }
}
