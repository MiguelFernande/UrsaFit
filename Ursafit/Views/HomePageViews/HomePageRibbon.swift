//
//  HomePageRibbon.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/10/24.
//

import SwiftUI

// MARK: - Ribbon Button
struct RibbonButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    let isMainButton: Bool

    var body: some View {
        Button(action: action) {
            VStack {
                Image(icon)
                    .resizable()
                    .frame(width: 75, height: 75, alignment: .center)
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

import SwiftUI

struct HomePageRibbon: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @Binding var showingWorkoutPrompt: Bool

    var body: some View {
        HStack(spacing: 0) {
            RibbonButton(
                icon: "Bear_Eat",
                title: "Nutrition",
                action: { coordinator.navPath.append(.nutrition) },
                isMainButton: false
            )
            
            RibbonButton(
                icon: "Bear_Lifting",
                title: "Workouts",
                action: { coordinator.navPath.append(.lifting) },
                isMainButton: false
            )
            
            RibbonButton(
                icon: "BearJog",
                title: "Start",
                action: { coordinator.isWorkoutPromptVisible = true },
                isMainButton: true
            )
            
            RibbonButton(
                icon: "Bear_Cart",
                title: "Shop",
                action: { coordinator.navPath.append(.shop) },
                isMainButton: false
            )
            
            RibbonButton(
                icon: "BoyBear_Profile",
                title: "Profile",
                action: { coordinator.navPath.append(.profile) },
                isMainButton: false
            )
        }
        .background(Color(.systemBackground))
        .shadow(radius: 2)
    }
}


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
        path.move(to: CGPoint(x: 0, y: height + 75))
        
        // Left point where triangle starts
        path.addLine(to: CGPoint(x: 0, y: extraHeight + -55))
        
        // Top point of triangle
        path.addLine(to: CGPoint(x: width/2, y: -75))
        
        // Right point where triangle starts
        path.addLine(to: CGPoint(x: width, y: extraHeight - 55))
        
        // Bottom right
        path.addLine(to: CGPoint(x: width, y: height + 75))
        
        path.closeSubpath()
        
        return path
    }
}
