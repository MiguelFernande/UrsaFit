//
//  WorkoutDataObserver.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 12/9/24.
//

import HealthKit

class WorkoutDataObserver {
    private let healthStore = HKHealthStore()
    private var observerQueries: [HKObserverQuery] = []
    private var updateHandler: (() -> Void)?
    
    func startObserving(updateHandler: @escaping () -> Void) {
        self.updateHandler = updateHandler
        
        // Observe active energy burned
        observe(type: .activeEnergyBurned)
        
        // Observe distance
        observe(type: .distanceWalkingRunning)
        
        
        enableBackgroundDelivery()
    }
    
    private func enableBackgroundDelivery() {
        let calorieType = HKQuantityType(.activeEnergyBurned)
        let distanceType = HKQuantityType(.distanceWalkingRunning)
        
        [calorieType, distanceType].forEach { type in
            healthStore.enableBackgroundDelivery(for: type, frequency: .immediate) { success, error in
                if let error = error {
                    print("Failed to enable background delivery: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func observe(type: HKQuantityTypeIdentifier) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: type) else { return }
        
        let query = HKObserverQuery(sampleType: quantityType, predicate: nil) { [weak self] _, _, error in
            if let error = error {
                print("Observer query error: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self?.updateHandler?()
            }
        }
        
        healthStore.execute(query)
        observerQueries.append(query)
    }
    
    func stopObserving() {
        observerQueries.forEach { healthStore.stop($0) }
        observerQueries.removeAll()
    }
}
