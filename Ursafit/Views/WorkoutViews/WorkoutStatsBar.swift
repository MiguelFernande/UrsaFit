//
//  WorkoutStatsBar.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/17/24.
//

import SwiftUI

struct WorkoutStatsBar: View {
    let streak: Int
    let calories: Int
    let elapsedTime: String
    let isPaused: Bool
    
    var body: some View {
        HStack {
            Text("🔥 \(streak)")
            Spacer()
            Text("\(calories) cal")
            Spacer()
            Text(elapsedTime)
        }
        .font(.system(size: 24, weight: .bold))
        .foregroundColor(isPaused ? .black : .white)
        .padding(.horizontal)
        .padding(.top)
    }
}
