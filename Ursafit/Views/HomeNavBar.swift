//
//  HomeNavBar.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import SwiftUI

struct HomeNavBar: View {
    let streakCount: Int
    let coinCount: Int
    
    var body: some View {
        HStack {
            Text("\(coinCount) 🪙")
                .font(.headline)
            
            Spacer()
            
            Text("🔥 \(streakCount)")
                .font(.headline)
            
            Spacer()
            
            // Placeholder for friends button
            NavigationLink(destination: Text("Friends View - Coming Soon")) {
                // TODO: Replace with actual friends icon
                Image(systemName: "person.2.fill")
                    .font(.title2)
                    .foregroundColor(.purple)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview
struct HomeNavBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeNavBar(streakCount: 5, coinCount: 100)
    }
}
