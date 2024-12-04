//
//  WorkoutBuilder.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/15/24.
//

import HealthKit
import Foundation

class WorkoutBuilder {
    private let healthStore: HKHealthStore
    private var workoutBuilder: HKWorkoutBuilder?
    private var startDate: Date?
    private var isWorkoutActive = false

    // Configuration
    private let workoutType: HKWorkoutActivityType

    init(healthStore: HKHealthStore, workoutType: HKWorkoutActivityType = .running) {
        self.healthStore = healthStore
        self.workoutType = workoutType
    }

    // MARK: - Core Workout Functions
    func startWorkout() async throws {
        guard !isWorkoutActive else { return }

        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor

        workoutBuilder = HKWorkoutBuilder(
            healthStore: healthStore,
            configuration: configuration,
            device: .local()
        )

        startDate = Date()
        try await workoutBuilder?.beginCollection(at: startDate ?? Date())
        isWorkoutActive = true
    }

    func endWorkout() async throws -> HKWorkout {
        guard let builder = workoutBuilder, isWorkoutActive else {
            throw WorkoutBuilderError.noActiveWorkout
        }

        let endDate = Date()
        try await builder.endCollection(at: endDate)

        guard let workout = try await builder.finishWorkout() else {
            throw WorkoutBuilderError.invalidWorkoutState
        }

        isWorkoutActive = false
        workoutBuilder = nil
        return workout
    }

    // MARK: - Sample Collection
    func addWorkoutSamples(
        distance: HKQuantity?,
        calories: HKQuantity?,
        date: Date
    ) async throws {
        guard let builder = workoutBuilder, isWorkoutActive else {
            throw WorkoutBuilderError.noActiveWorkout
        }

        var samples: [HKSample] = []

        if let distance = distance {
            let distanceSample = HKQuantitySample(
                type: HKQuantityType(.distanceWalkingRunning),
                quantity: distance,
                start: date,
                end: date
            )
            samples.append(distanceSample)
        }

        if let calories = calories {
            let caloriesSample = HKQuantitySample(
                type: HKQuantityType(.activeEnergyBurned),
                quantity: calories,
                start: date,
                end: date
            )
            samples.append(caloriesSample)
        }

        do {
            if !samples.isEmpty {
                try await builder.addSamples(samples)
            }
        } catch {
            print("Failed to add samples: \(error.localizedDescription)")
            throw WorkoutBuilderError.healthKitError(error)
        }
    }

    // MARK: - Test Workout Creation
    enum TestWorkoutType {
        case short  // 10 min workout
        case medium // 15 min workout
    }

    func createTestWorkout(type: TestWorkoutType) async throws -> HKWorkout {
        let (duration, distance, calories) = testWorkoutParameters(for: type)
        
        try await startWorkout()
        
        do {
            // Add test samples
            let date = Date()
            try await addWorkoutSamples(
                distance: HKQuantity(unit: .meter(), doubleValue: distance),
                calories: HKQuantity(unit: .smallCalorie(), doubleValue: calories),
                date: date
            )
            
            // Simulate workout duration
            try await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            
            return try await endWorkout()
        } catch {
            print("Error during test workout creation: \(error.localizedDescription)")
            throw error
        }
    }
    
    func testWorkoutParameters(for type: TestWorkoutType) -> (duration: TimeInterval, distance: Double, calories: Double) {
        switch type {
        case .short:
            return (duration: 600, distance: 2000, calories: 200)  // 10 min, 2km, 200 cal
        case .medium:
            return (duration: 900, distance: 3000, calories: 300)  // 15 min, 3km, 300 cal
        }
    }
}

// MARK: - Errors
enum WorkoutBuilderError: Error {
    case noActiveWorkout
    case invalidWorkoutState
    case healthKitError(Error)
}

