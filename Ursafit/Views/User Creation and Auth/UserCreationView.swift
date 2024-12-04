//
//  UserCreationView.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 12/1/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UserCreationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var name = ""  // Added for full name
    @State private var errorMessage: String? = nil
    @State private var isLoading = false
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var mainViewModel: MainViewModel

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Create an Account")
                .font(.largeTitle)
                .bold()

            TextField("Full Name", text: $name)  // New field for name
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.words)

            TextField("Username", text: $username)  // Made username required
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button(action: createUser) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .disabled(isLoading || email.isEmpty || password.isEmpty || name.isEmpty || username.isEmpty)

            Spacer()
        }
        .padding()
    }

    private func createUser() {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty, !username.isEmpty else {
            errorMessage = "All fields are required."
            return
        }

        isLoading = true
        errorMessage = nil

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }

            guard let user = result?.user else {
                errorMessage = "Failed to create user."
                return
            }

            saveUserToDatabase(user: user)
        }
    }

    private func saveUserToDatabase(user: FirebaseAuth.User) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "email": user.email ?? "",
            "name": name,
            "username": username,
            "currentStreak": 0,
            "bearCoins": 0,
            "streakFreezes": 0,
            "scheduleType": WorkoutScheduleType.loose.rawValue,
            "workoutDays": [],
            "weeklyWorkoutCount": 0,
            "createdAt": FieldValue.serverTimestamp()
        ]

        db.collection("users").document(user.uid).setData(userData) { error in
            if let error = error {
                errorMessage = "Failed to save user data: \(error.localizedDescription)"
            } else {
                // Update the MainViewModel's user
                mainViewModel.user = User(
                    name: name,
                    username: username,
                    currentStreak: 0,
                    bearCoins: 0,
                    streakFreezes: 0,
                    scheduleType: .loose,
                    workoutDays: [],
                    weeklyWorkoutCount: 0
                )
                
                // Navigate to workout setup
                coordinator.navPath.append(.setup)
            }
        }
    }
}
