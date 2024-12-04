//
//  AuthView.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 12/1/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct AuthView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image("BearJog")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text("Welcome to UrsaFit")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Track your workouts and maintain your streak!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            // Login Button
            Button(action: {
                coordinator.navPath.append(.login)
            }) {
                Text("Login")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            // Create Account Button
            Button(action: {
                coordinator.navPath.append(.createAccount)
            }) {
                Text("Create Account")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Spacer()
                .frame(height: 50)
        }
        .padding()
    }
}
