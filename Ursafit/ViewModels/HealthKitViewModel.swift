//
//  HealthKitViewModel.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import SwiftUI

class HealthKitViewModel: ObservableObject {
    
    @Published private(set) var authorizationStatus: HealthKitAuthorizationStatus = .notDetermined
    @Published private(set) var errorMessage: String?
    @Published var isRequestingAuthorization = false
    
    private let healthKitService = HealthKitService.shared
    
    func requestHealthKitAuthorization() {
        guard !isRequestingAuthorization else { return }

        isRequestingAuthorization = true
        
        Task {
            do {
                _ = try await healthKitService.requestAuthorization()
                await updateAuthorizationStatus()
            } catch {
                errorMessage = handleError(error)
            }
            
            isRequestingAuthorization = false
        }
    }
    
    func updateAuthorizationStatus() async {
        authorizationStatus = await healthKitService.checkAuthorizationStatus()
    }
    
    private func handleError(_ error: Error) -> String {
        switch error {
        case HealthKitError.notAvailable:
            return "HealthKit is not available on this device"
        case HealthKitError.authorizationFailed:
            return "Failed to get authorization for HealthKit"
        default:
            return "An unknown error occurred"
        }
    }
}
