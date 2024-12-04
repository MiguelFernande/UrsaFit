//
//  LoginView.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 12/1/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String? = nil
    @State private var isLoading = false

    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Log In")
                .font(.largeTitle)
                .bold()

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

            Button(action: loginUser) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .disabled(isLoading || email.isEmpty || password.isEmpty)

            Spacer()
        }
        .padding()
    }

    private func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return
        }

        isLoading = true
        errorMessage = nil

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                handleAuthError(error)
                return
            }

            guard let user = result?.user else {
                errorMessage = "Failed to log in."
                return
            }

            navigateToMainApp(user: user)
        }
    }

    private func handleAuthError(_ error: Error) {
        if let authError = error as NSError? {
            switch AuthErrorCode(rawValue: authError.code) {
            case .userNotFound:
                errorMessage = "No user found for this email."
            case .wrongPassword:
                errorMessage = "Incorrect password."
            case .invalidEmail:
                errorMessage = "Invalid email format."
            case .networkError:
                errorMessage = "Network error. Please try again."
            default:
                errorMessage = "Login failed: \(authError.localizedDescription)"
            }
        } else {
            errorMessage = "An unknown error occurred."
        }
    }

    private func navigateToMainApp(user: FirebaseAuth.User) {
        coordinator.navPath.removeAll()
    }
}
