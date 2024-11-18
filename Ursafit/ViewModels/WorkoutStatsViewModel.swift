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
    
    private let statsManager = WorkoutStatsManager()
    
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
    }
    
    func incrementTime() {
        stats.elapsedTime += 1
    }
}
