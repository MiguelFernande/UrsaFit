//
//  WorkoutService.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import HealthKit

class WorkoutService {
    static let shared = WorkoutService()
    private let healthStore = HKHealthStore()
    private var workoutBuilder: WorkoutBuilder?
    private let permissionService: PermissionService

    
    private init() {
        self.permissionService = PermissionService.shared
        self.workoutBuilder = WorkoutBuilder(healthStore: healthStore)
    }

    // MARK: - Workout Operations
    func startWorkout() async throws {
        try await workoutBuilder?.startWorkout()
    }

    func endWorkout() async throws -> HKWorkout {
        guard let workout = try await workoutBuilder?.endWorkout() else {
            throw HealthKitError.workoutError(
                NSError(domain: "WorkoutService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to end workout"])
            )
        }
        return workout
    }

    func updateWorkoutData(distance: Double?, calories: Double?, date: Date = Date()) async throws {
        try await workoutBuilder?.addWorkoutSamples(
            distance: distance != nil ? HKQuantity(unit: .meter(), doubleValue: distance!) : nil,
            calories: calories != nil ? HKQuantity(unit: .smallCalorie(), doubleValue: calories!) : nil,
            date: date
        )
    }

    func createTestWorkout(type: WorkoutBuilder.TestWorkoutType) async throws -> HKWorkout {
        // First check authorization
        if permissionService.checkAuthorizationStatus() != .authorized {
            _ = try await permissionService.requestAuthorization()
        }
        // Then create the test workout
        guard let workout = try await workoutBuilder?.createTestWorkout(type: type) else {
            throw HealthKitError.workoutError(
                NSError(domain: "WorkoutService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create test workout"])
            )
        }
        return workout
    }

    // MARK: - Query Operations
    func fetchRecentWorkouts() async throws -> [WorkoutEntry] {
        let workoutType = HKObjectType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let now = Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: now)!
        let datePredicate = HKQuery.predicateForSamples(withStart: thirtyDaysAgo, end: now)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: workoutType,
                predicate: datePredicate,
                limit: 20,
                sortDescriptors: [sortDescriptor]
            ) { (_, samples, error) in
                if let error = error {
                    continuation.resume(throwing: HealthKitError.readError(error))
                    return
                }

                let workouts = (samples as? [HKWorkout] ?? []).map { WorkoutEntry(from: $0) }
                continuation.resume(returning: workouts)
            }

            healthStore.execute(query)
        }
    }
}
