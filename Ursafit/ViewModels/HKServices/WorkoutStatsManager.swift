//
//  WorkoutStatsManager.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/17/24.
//

import HealthKit

class WorkoutStatsManager {
    private let healthStore = HKHealthStore()
    
    func fetchLiveStats(from startTime: Date) async -> (calories: Double, distance: Double) {
        let calorieType = HKQuantityType(.activeEnergyBurned)
        let distanceType = HKQuantityType(.distanceWalkingRunning)
        
        // Create a predicate for samples between start time and now
        let now = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startTime, end: now)
        
        // Fetch calories with cumulative sum
        let calories = await fetchStatistic(
            type: calorieType,
            predicate: predicate,
            unit: .kilocalorie(),
            options: .cumulativeSum
        )
        
        // Fetch distance
        let distance = await fetchStatistic(
            type: distanceType,
            predicate: predicate,
            unit: .meter(),
            options: .cumulativeSum
        )
        
        return (calories: calories ?? 0, distance: distance ?? 0)
    }
    
    private func fetchStatistic(
        type: HKQuantityType,
        predicate: NSPredicate,
        unit: HKUnit,
        options: HKStatisticsOptions
    ) async -> Double? {
        await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: options
            ) { _, result, error in
                if let error = error {
                    print("Error fetching statistics: \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                    return
                }
                
                let value = result?.sumQuantity()?.doubleValue(for: unit)
                continuation.resume(returning: value)
            }
            
            healthStore.execute(query)
        }
    }
}
