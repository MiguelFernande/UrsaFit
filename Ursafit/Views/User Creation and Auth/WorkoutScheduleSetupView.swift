//
//  WorkoutScheduleSetupView.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 12/1/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseAuthUI

struct WorkoutScheduleSetupView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var mainViewModel: MainViewModel
    @State private var selectedScheduleType: WorkoutScheduleType = .loose
    @State private var selectedDays = Set<Weekday>()
    @State private var weeklyWorkoutCount: Int = 3
    
    var body: some View {
        VStack(spacing: 0) { // Remove default spacing
            // Header Section - Fixed Height
            VStack(spacing: 8) {
                Text("Set Your Workout Schedule")
                    .font(.largeTitle)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                
                Text("Choose how you'd like to schedule your workouts")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            
            // Card Selection Section - Fixed Height
            VStack(spacing: 12) {
                Button {
                    selectedScheduleType = .strict
                } label: {
                    ScheduleOptionCard(
                        title: "Specific Days",
                        description: "Work out on certain days of the week",
                        isSelected: selectedScheduleType == .strict
                    )
                }
                
                Button {
                    selectedScheduleType = .loose
                } label: {
                    ScheduleOptionCard(
                        title: "Flexible Schedule",
                        description: "Work out any days, set times per week",
                        isSelected: selectedScheduleType == .loose
                    )
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 180) // Fixed height for cards section
            
            // Schedule Details Section - Fixed Frame
            ScrollView {
                if selectedScheduleType == .strict {
                    StrictScheduleView(selectedDays: $selectedDays)
                } else {
                    LooseScheduleView(weeklyWorkoutCount: $weeklyWorkoutCount)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300) // Fixed height for details section
            
            Spacer(minLength: 20)
            
            // Button Section - Fixed Height
            Button {
                mainViewModel.user.scheduleType = selectedScheduleType
                mainViewModel.user.workoutDays = selectedDays
                mainViewModel.user.weeklyWorkoutCount = weeklyWorkoutCount
                
                Task {
                    do {
                        try await UserDatabaseService().createUserProfile(user: mainViewModel.user)
                    } catch {
                        print("Error saving user schedule: \(error.localizedDescription)")
                    }
                }
                
                coordinator.navPath.removeAll()
            } label: {
                Text("Confirm Schedule")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}

struct ScheduleOptionCard: View {
    let title: String
    let description: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3))
        )
    }
}

struct StrictScheduleView: View {
    @Binding var selectedDays: Set<Weekday>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select workout days:")
                .font(.headline)
            
            ForEach(Weekday.allCases, id: \.self) { day in
                Button {
                    if selectedDays.contains(day) {
                        selectedDays.remove(day)
                    } else {
                        selectedDays.insert(day)
                    }
                } label: {
                    HStack {
                        Image(systemName: selectedDays.contains(day) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.blue)
                        Text(day.rawValue.capitalized)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
            }
        }
        .padding()
    }
}

struct LooseScheduleView: View {
    @Binding var weeklyWorkoutCount: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Workouts per week:")
                .font(.headline)
            
            Stepper(value: $weeklyWorkoutCount, in: 1...7) {
                Text("\(weeklyWorkoutCount) times per week")
            }
        }
        .padding()
    }
}
