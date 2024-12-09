//
//  WorkoutStatsViewModel.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/17/24.
//

import SwiftUI

@MainActor
class WorkoutStatsViewModel: ObservableObject {
    @Published private(set) var stats = WorkoutStats()
    @Published var isPaused = false
    @Published private(set) var startTime: Date?
    
    private let statsManager = WorkoutStatsManager()
    private let workoutObserver = WorkoutDataObserver()

    func startObserving(startTime: Date) {
        self.startTime = startTime
        workoutObserver.startObserving { [weak self] in
            guard let self = self else { return }
            Task {
                await self.updateStats(from: startTime)
            }
        }
    }
    
    func stopObserving() {
        workoutObserver.stopObserving()
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func togglePause() {
        isPaused.toggle()
    }
    
    func updateStats(from startTime: Date) async {
        let newStats = await statsManager.fetchLiveStats(from: startTime)
        stats.update(calories: newStats.calories, distance: newStats.distance)
    }
    
    func resetStats() {
        stats.reset()
        startTime = nil
    }
    
    func incrementTime() {
        stats.elapsedTime += 1
    }
}
