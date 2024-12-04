//
//  HomeNavBar.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import SwiftUI
import FirebaseAuth

struct HomeNavBar: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var mainViewModel: MainViewModel
    @State private var displayedCoins: Int = 0
    @State private var displayedStreak: Int = 0
    
    var body: some View {
        HStack {
            Text("\(displayedCoins) 🪙")
                .font(.headline)
            
            Spacer()
            
            Text("🔥 \(displayedStreak)")
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                coordinator.navPath.append(.friend)
            }) {
                Image(systemName: "person.2.fill")
                    .font(.title2)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .onAppear {
            fetchLatestUserData()
        }
    }
    
    private func fetchLatestUserData() {
        Task {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            do {
                let userDatabaseService = UserDatabaseService()
                let user = try await userDatabaseService.fetchUserProfile(userID: userId)
                await MainActor.run {
                    displayedCoins = user.bearCoins
                    displayedStreak = user.currentStreak
                    
                    // Update MainViewModel to keep it in sync
                    mainViewModel.user.bearCoins = user.bearCoins
                    mainViewModel.user.currentStreak = user.currentStreak
                }
            } catch {
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
}
