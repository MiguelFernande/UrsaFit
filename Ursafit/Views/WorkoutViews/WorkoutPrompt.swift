//
//  WorkoutPrompt.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/15/24.
//

import SwiftUI

struct WorkoutPrompt: View {
    @Binding var isShowing: Bool
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Left side - Bear Image
                VStack {
                    Image("BearPose")
                        .resizable()
                        .frame(width: 200, height: 750, alignment: .center)
                }
                .frame(width: geometry.size.width * 0.6)
                
                // Right side - Buttons
                VStack(spacing: 30) {
                    
                    Text("Ready to workout?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                    
                    // No Button
                    Button(action: {
                        coordinator.isWorkoutPromptVisible = false
                    }) {
                        Text("No")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 5)
                    
                    // Yes Button
                    Button(action: {
                        coordinator.isWorkoutPromptVisible = false
                        coordinator.navPath.append(.countdown)
                    }) {
                        Text("Yes")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
        } 
    }
}
