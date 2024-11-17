//
//  CoordinatorView.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/16/24.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator(mainViewModel: MainViewModel(
        user: User(name: "TestName", username: "Test User"),
        workoutService: WorkoutService.shared,
        permissionService: PermissionService.shared
    ))

    var body: some View {
        NavigationStack(path: $coordinator.navPath) {
            coordinator.build(route: .home)
                .navigationDestination(for: AppRoute.self) { route in
                    coordinator.build(route: route)
                }
        }
        .environmentObject(coordinator) // Inject AppCoordinator globally
    }
}
