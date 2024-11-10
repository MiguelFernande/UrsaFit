//
//  HomePageRibbon.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import SwiftUI

// MARK: - Pentagon Shape for Main Button
struct PentagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // This controls how tall the triangle part is
        // 0.2 = 20% of height, 0.5 = 50% of height
        let extraHeight = height * 0.5
        
        // You can adjust these points to change the shape:
        
        // Bottom left
        path.move(to: CGPoint(x: 0, y: height))
        
        // Left point where triangle starts
        path.addLine(to: CGPoint(x: 0, y: extraHeight + -33))
        
        // Top point of triangle
        path.addLine(to: CGPoint(x: width/2, y: -33))
        
        // Right point where triangle starts
        path.addLine(to: CGPoint(x: width, y: extraHeight - 34))
        
        // Bottom right
        path.addLine(to: CGPoint(x: width, y: height))
        
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Ribbon Button
struct RibbonButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    let isMainButton: Bool
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: isMainButton ? 32 : 24))
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(isMainButton ?
                       PentagonShape()
                           .fill(Color.blue)
                           .frame(height: 65) : nil
            )
            .foregroundColor(isMainButton ? .white : .primary)
        }
    }
}

// MARK: - Home Page Ribbon
struct HomePageRibbon: View {
    @Binding var showingWorkoutPrompt: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            RibbonButton(
                icon: "heart.text.square",
                title: "Nutrition",
                action: { /* TODO: Nutrition View */ },
                isMainButton: false
            )
            
            RibbonButton(
                icon: "figure.walk",
                title: "Workouts",
                action: { /* TODO: Workouts View */ },
                isMainButton: false
            )
            
            RibbonButton(
                icon: "plus.circle.fill",
                title: "Start",
                action: { showingWorkoutPrompt = true },
                isMainButton: true
            )
            
            RibbonButton(
                icon: "cart",
                title: "Shop",
                action: { /* TODO: Shop View */ },
                isMainButton: false
            )
            
            RibbonButton(
                icon: "person.circle",
                title: "Profile",
                action: { /* TODO: Profile View */ },
                isMainButton: false
            )
        }
        .background(Color(.systemBackground))
        .shadow(radius: 2)
    }
}

// MARK: - Preview
struct HomePageRibbon_Previews: PreviewProvider {
    static var previews: some View {
        HomePageRibbon(showingWorkoutPrompt: .constant(false))
    }
}
