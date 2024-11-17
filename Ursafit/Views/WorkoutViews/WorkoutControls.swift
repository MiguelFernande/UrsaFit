//
//  WorkoutControls.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/17/24.
//

import SwiftUI

struct WorkoutControls: View {
    let isPaused: Bool
    let onPause: () -> Void
    let onResume: () -> Void
    let onStop: () -> Void
    
    var body: some View {
        if isPaused {
            HStack(spacing: 50) {
                Button(action: onResume) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.black)
                }
                
                Button(action: onStop) {
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.black)
                }
            }
        } else {
            Button(action: onPause) {
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.white)
            }
        }
    }
}
