//
//  HealthKitPermissions.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import SwiftUI

struct HealthKitPermissionView: View {
    @ObservedObject var healthKitVM: HealthKitViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Icon
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            // Title
            Text("Health Access Required")
                .font(.title2)
                .bold()
            
            // Description
            Text("UrsaFit needs access to your health data to track workouts and maintain your streak. This helps us provide you with the best experience.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            // Button
            Button(action: {
                healthKitVM.requestHealthKitAuthorization()
                isPresented = false
            }) {
                Text("Enable HealthKit Access")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            // Skip button
            Button(action: {
                isPresented = false
            }) {
                Text("Maybe Later")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: 340)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 20)
    }
}
