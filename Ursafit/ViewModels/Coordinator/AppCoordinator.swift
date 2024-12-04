//
//  AppCoordinator.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseAuthUI

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
    case auth
    case setup
    case login
    case createAccount
}

enum AuthenticationState {
    case unknown
    case authenticated(User)
    case unauthenticated
    case newUser
}

// MARK: - App Coordinator

class AppCoordinator: ObservableObject {
    @Published var navPath = [AppRoute]()
    @Published var isWorkoutPromptVisible: Bool = false
    @Published var showAuthSheet = false
    @Published var isAuthenticated = false
    
    let mainViewModel: MainViewModel
    let nutrionViewModel: NutritionTopicsViewModel

    init(mainViewModel: MainViewModel, nutrionViewModel: NutritionTopicsViewModel) {
        self.mainViewModel = mainViewModel
        self.nutrionViewModel = nutrionViewModel
    }
    
    func checkAuthState() {
        if Auth.auth().currentUser != nil {
            self.isAuthenticated = true
        } else {
            self.showAuthSheet = true
        }
    }

    func build(route: AppRoute) -> some View {
        print("Building view for route: \(route)")
        switch route {
        case .home:
            return AnyView(HomePage().environmentObject(mainViewModel))
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
            return AnyView(ExerciseListView(viewModel: ExerciseViewModel()))
        case .auth:
            return AnyView(AuthView())
        case .setup:
            return AnyView(WorkoutScheduleSetupView().environmentObject(mainViewModel))
        case .login:
            return AnyView(LoginView())
        case .createAccount:
            return AnyView(UserCreationView().environmentObject(mainViewModel))
        }
    }
}
