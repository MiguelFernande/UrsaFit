//
//  HomePage.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 10/28/24.
//

import SwiftUI

struct HomePage: View {
    @StateObject var viewModel: MainViewModel
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack {
                    // Top Navigation Bar
                    HomeNavBar(
                        streakCount: viewModel.user.currentStreak,
                        coinCount: viewModel.user.bearCoins
                    )

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

// MARK: - Preview
struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUser = User(
            name: "John Doe",
            username: "johndoe",
            currentStreak: 10,
            bearCoins: 100
        )
        let viewModel = MainViewModel(
            user: sampleUser,
            workoutService: WorkoutService.shared,
            permissionService: PermissionService.shared
        )

        return HomePage(viewModel: viewModel)
            .environmentObject(AppCoordinator(mainViewModel: viewModel))
    }
}
