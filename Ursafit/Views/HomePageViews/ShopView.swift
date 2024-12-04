//
//  ShopView.swift
//  Ursafit
//

import SwiftUI
import FirebaseAuth

struct ShopView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var displayedCoins: Int = 0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Display the current coins
                HStack {
                    Text("Coins: \(displayedCoins)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)
                }
                .padding(.bottom, 20)
                
                // Donate Button
                Button(action: {
                    let success = viewModel.donateToUncleLarry()
                    if success {
                        updateDisplayedCoins()
                    } else {
                        print("Donation failed!")
                    }
                }) {
                    Text("Donate to Uncle Larry (-150 Coins)")
                        .padding()
                        .background(viewModel.user.bearCoins >= 150 ? Color.red : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.user.bearCoins < 150) // Disable if insufficient coins
                
                // Buy Streak Freeze Button
                Button(action: {
                    let success = viewModel.buyStreakFreeze()
                    if success {
                        updateDisplayedCoins()
                    } else {
                        print("Purchase failed!")
                    }
                }) {
                    Text("Buy a Streak Freeze (-100 Coins)")
                        .padding()
                        .background(viewModel.user.bearCoins >= 100 ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.user.bearCoins < 100) // Disable if insufficient coins
            }
            .padding()
            .navigationTitle("Shop")
            .onAppear {
                updateDisplayedCoins() // Initialize the local state
            }
            .onDisappear {
                Task {
                    await viewModel.updateCoinsInDatabase()
                }
            }
        }
    }
    
    private func fetchLatestCoins() {
        Task {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            do {
                let userDatabaseService = UserDatabaseService()
                let user = try await userDatabaseService.fetchUserProfile(userID: userId)
                await MainActor.run {
                    viewModel.user.bearCoins = user.bearCoins
                    displayedCoins = user.bearCoins
                }
            } catch {
                print("Error fetching coins: \(error.localizedDescription)")
            }
        }
    }
    
    // Updates the displayed coin count
    private func updateDisplayedCoins() {
        displayedCoins = viewModel.user.bearCoins
    }
}
