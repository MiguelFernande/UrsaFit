//
//  CountdownView.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/16/24.
//

import SwiftUI

struct CountdownView: View {
    @State private var countdown = 3
    @EnvironmentObject private var coordinator: AppCoordinator
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            Text("\(countdown)")
                .font(.system(size: 120, weight: .bold))
                .foregroundColor(.white)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onReceive(timer) { _ in
            if countdown > 1 {
                countdown -= 1
            } else {
                // Cancel the timer to prevent multiple calls
                timer.upstream.connect().cancel()
                coordinator.navPath.append(.workout)
            }
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
}
