//
//  ContentView.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 10/28/24.
//

import SwiftUI

struct HomePage: View {
    @StateObject var viewModel: MainViewModel
    @State private var showingWorkoutPrompt = false
    @State private var showingHealthKitPrompt = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Navigation Bar
                    HomeNavBar(
                        streakCount: viewModel.user.currentStreak,
                        coinCount: viewModel.user.bearCoins
                    )
                    
                    // Workout Feed
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.workoutFeed) { workout in
                                HomePageCell(workout: workout)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                    
                    // Bottom Ribbon
                    HomePageRibbon(showingWorkoutPrompt: $showingWorkoutPrompt)
                }
            }
            .navigationBarHidden(true)
            .task{
                await checkHealthKitAuthorization()
            }
        }
        .sheet(isPresented: $showingWorkoutPrompt) {
            Text("Workout Prompt - Coming Soon")
                .padding()
        }
        .overlay {
            if showingHealthKitPrompt{
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay {
                        HealthKitPermissionView(
                            healthKitVM: viewModel.healthKitVM,
                            isPresented: $showingHealthKitPrompt
                        )
                        .transition(.scale)
                    }
            }
        }
        .animation(.easeInOut, value: showingHealthKitPrompt)
    }
    
    private func checkHealthKitAuthorization() async {
        await viewModel.healthKitVM.updateAuthorizationStatus()
        
        if viewModel.healthKitVM.authorizationStatus == .notDetermined || viewModel.healthKitVM.authorizationStatus == .denied {
            showingHealthKitPrompt == true
        }
    }
}

// MARK: - Preview
struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUser = User(
            name: "John Doe",
            username: "johndoe",
            currentStreak: 10,
            bearCoins: 100
        )
        HomePage(viewModel: MainViewModel(user: sampleUser))
    }
}
