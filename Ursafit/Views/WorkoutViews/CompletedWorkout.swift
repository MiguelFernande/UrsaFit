//
//  CompletedWorkoutView.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/16/24.
//

import SwiftUI

struct CompletedWorkout: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var countdown = 5
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            
            Image("Bear_Thumbs_Up")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Workout Completed!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                Text("\(countdown)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .onReceive(timer) { _ in
            if countdown > 0 {
                countdown -= 1
            } else {
                coordinator.navPath.removeAll()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
