//
//  ProfileView.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/16/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        NavigationView {
            List {
                // Section for User Info
                Section(header: Text("User Info")) {
                    Text("Username: \(viewModel.user.username)")
                    Text("Current Streak: \(viewModel.user.currentStreak) days")
                    Text("Bear Coins: \(viewModel.user.bearCoins)")
                }

                // Section for Streak Freezes
                Section(header: Text("Inventory")) {
                    if viewModel.user.streakFreezes > 0 {
                        Text("Streak Freezes: \(viewModel.user.streakFreezes)")
                    } else {
                        Text("No items in inventory.")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

