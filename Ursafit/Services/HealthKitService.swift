//
//  HealthKitService.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import HealthKit

class HealthKitService {
    static let shared = HealthKitService() // Singleton pattern
    private let healthStore = HKHealthStore()
    
    private init() {} // Enforce singleton
    
    // The types we want to read/write
    private let readTypes: Set<HKSampleType> = [
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKQuantityType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.workoutType()
    ]
    
    private let writeTypes: Set<HKSampleType> = [
        HKObjectType.workoutType()
    ]
    
    var isHealthKitAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    // Authorization request
    func requestAuthorization() async throws -> Bool {
        guard isHealthKitAvailable else {
            throw HealthKitError.notAvailable
        }
        
        do {
            try await healthStore.requestAuthorization(toShare: writeTypes, read: readTypes)
            return true
        } catch {
            throw HealthKitError.authorizationFailed(error)
        }
    }
    
    // Check authorization status
    func checkAuthorizationStatus() async -> HealthKitAuthorizationStatus {
        guard isHealthKitAvailable else {
            return .notAvailable
        }
        
        // Check status for workout type as an example
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

// Custom enums for cleaner error and status handling
enum HealthKitError: Error {
    case notAvailable
    case authorizationFailed(Error)
    case readError(Error)
    case writeError(Error)
}

enum HealthKitAuthorizationStatus {
    case notAvailable
    case notDetermined
    case denied
    case authorized
    case unknown
}
