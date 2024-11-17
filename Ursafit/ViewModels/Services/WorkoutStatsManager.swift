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
        let predicate = HKQuery.predicateForSamples(withStart: startTime, end: nil)
        
        let calories = await fetchStatistic(type: calorieType, predicate: predicate, unit: .smallCalorie())
        let distance = await fetchStatistic(type: distanceType, predicate: predicate, unit: .meter())
        
        return (calories: calories ?? 0, distance: distance ?? 0)
    }
    
    private func fetchStatistic(type: HKQuantityType, predicate: NSPredicate, unit: HKUnit) async -> Double? {
        await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, _ in
                let value = result?.sumQuantity()?.doubleValue(for: unit)
                continuation.resume(returning: value)
            }
            healthStore.execute(query)
        }
    }
}
