//
//  PermissionService.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import HealthKit

class PermissionService {
    static let shared = PermissionService()
    private let healthStore = HKHealthStore()

    private init() {}

    // MARK: - Authorization
    var isHealthKitAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestAuthorization() async throws -> Bool {
        let typesToShare: Set<HKSampleType> = [
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.activeEnergyBurned),
            HKWorkoutType.workoutType()
        ]

        let typesToRead: Set<HKObjectType> = [
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.activeEnergyBurned),
            HKWorkoutType.workoutType()
        ]

        return try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
                if let error = error {
                    continuation.resume(throwing: HealthKitError.authorizationFailed(error))
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }

    func checkAuthorizationStatus() -> HealthKitAuthorizationStatus {
        guard isHealthKitAvailable else {
            return .notAvailable
        }

        let status = healthStore.authorizationStatus(for: HKObjectType.workoutType())
        switch status {
        case .notDetermined:
            return .notDetermined
        case .sharingDenied:
            return .denied
        case .sharingAuthorized:
            return .authorized
        @unknown default:
            return .unknown
        }
    }
}

// MARK: - Error and Status Types
enum HealthKitError: Error {
    case notAvailable
    case authorizationFailed(Error)
    case readError(Error)
    case writeError(Error)
    case workoutError(Error)
}

enum HealthKitAuthorizationStatus {
    case notAvailable
    case notDetermined
    case denied
    case authorized
    case unknown
}
