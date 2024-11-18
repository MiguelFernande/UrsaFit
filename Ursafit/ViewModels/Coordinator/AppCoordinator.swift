//
//  AppCoordinator.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import SwiftUI

// MARK: - Navigation Routes
enum AppRoute: Hashable {
    case home
    case workout
    case completedWorkout
    case countdown
    case profile
    case nutrition
    case shop
    case lifting
    case friend
}

// MARK: - App Coordinator

class AppCoordinator: ObservableObject {
    @Published var navPath = [AppRoute]()
    @Published var isWorkoutPromptVisible: Bool = false // CHANGED: State for workout prompt visibility

    let mainViewModel: MainViewModel
    let nutrionViewModel: NutritionTopicsViewModel

    init(mainViewModel: MainViewModel, nutrionViewModel: NutritionTopicsViewModel) {
        self.mainViewModel = mainViewModel
        self.nutrionViewModel = nutrionViewModel
    }

    func build(route: AppRoute) -> some View {
        print("Building view for route: \(route)")
        switch route {
        case .home:
            return AnyView(HomePage(viewModel: self.mainViewModel))
        case .workout:
            return AnyView(WorkoutView().environmentObject(mainViewModel))
        case .completedWorkout:
            return AnyView(CompletedWorkout().environmentObject(self))
        case .countdown:
            return AnyView(CountdownView().environmentObject(self))
        case .profile:
            return AnyView(ProfileView().environmentObject(mainViewModel))
        case .nutrition:
            return AnyView(NutritionTopicsView())
        case .shop:
            return AnyView(ShopView().environmentObject(mainViewModel))
        case .friend:
            return AnyView(FriendsView())
        case .lifting:
            return AnyView(LiftingView())
        }
    }
}
