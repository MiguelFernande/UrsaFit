//
//  WorkoutView.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/16/24.
//

import SwiftUI
import HealthKit

struct WorkoutView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var workoutStatsViewModel = WorkoutStatsViewModel()
    
    var body: some View {
        ZStack {
            (workoutStatsViewModel.isPaused ? Color.white : Color.black)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                WorkoutStatsBar(
                    streak: viewModel.user.currentStreak,
                    calories: Int(workoutStatsViewModel.stats.calories),
                    elapsedTime: workoutStatsViewModel.stats.formattedTime,
                    isPaused: workoutStatsViewModel.isPaused
                )
                
                Spacer()
                
                Text(workoutStatsViewModel.stats.formattedDistance)
                    .font(.system(size: 72, weight: .bold))
                    .foregroundColor(workoutStatsViewModel.isPaused ? .black : .white)
                
                Spacer()
                
                WorkoutControls(
                    isPaused: workoutStatsViewModel.isPaused,
                    onPause: { workoutStatsViewModel.togglePause() },
                    onResume: {
                        workoutStatsViewModel.togglePause()
                        Task {
                            await updateStats()
                        }
                    },
                    onStop: {
                        Task {
                            await viewModel.endWorkout()
                            coordinator.navPath.append(.completedWorkout)
                        }
                    }
                )
                
                #if DEBUG
                debugButtons
                #endif
            }
            .padding(.bottom, 50)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .interactiveDismissDisabled(true)
        .onAppear {
            Task {
                workoutStatsViewModel.resetStats()
                await viewModel.startWorkout()
                if let startTime = viewModel.workoutStartTime {
                    workoutStatsViewModel.startObserving(startTime: startTime)
                }
            }
        }
        .onDisappear {
            workoutStatsViewModel.stopObserving()
        }
        .onReceive(workoutStatsViewModel.timer) { _ in
            if !workoutStatsViewModel.isPaused {
                workoutStatsViewModel.incrementTime()
                Task {
                    await updateStats()
                }
            }
        }
    }
    
    private func updateStats() async {
        guard let startTime = viewModel.workoutStartTime else { return }
        await workoutStatsViewModel.updateStats(from: startTime)
    }
    
    #if DEBUG
    private var debugButtons: some View {
        VStack {
            Button("Add small Test Workout") {
                Task {
                    do {
                        let workout = try await viewModel.workoutService.createTestWorkout(type: .short)
                        await MainActor.run {
                            viewModel.workoutFeed.append(WorkoutEntry(from: workout))
                            coordinator.navPath.append(.completedWorkout)
                        }
                    } catch {
                        print("Failed to create 10min Test Workout: \(error.localizedDescription)")
                    }
                }
            }
            .foregroundColor(workoutStatsViewModel.isPaused ? .black : .white)
            
            Button("Add normal Test Workout") {
                Task {
                    do {
                        let workout = try await viewModel.workoutService.createTestWorkout(type: .medium)
                        await MainActor.run {
                            viewModel.workoutFeed.append(WorkoutEntry(from: workout))
                            coordinator.navPath.append(.completedWorkout)
                        }
                    } catch {
                        print("Failed to create 20min Test Workout: \(error.localizedDescription)")
                    }
                }
            }
            .foregroundColor(workoutStatsViewModel.isPaused ? .black : .white)
        }
        .padding()
    }
    #endif
}
