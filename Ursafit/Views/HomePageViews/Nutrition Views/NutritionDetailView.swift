//
//  NutritionDetailView.swift
//  Ursafit
//
//  Created by Corey Buckingham on 11/16/24.
//

import SwiftUI

struct NutritionDetailView: View {
    let topic: NutritionTopic

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                // Details Section
                Text("Details")
                    .font(.headline)
                Text(topic.details)
                    .font(.body)
                    .padding(.bottom, 10)

                // Key Points Section
                if let keyPoints = topic.keyPoints, !keyPoints.isEmpty {
                    Text("Key Points")
                        .font(.headline)
                    ForEach(keyPoints, id: \.self) { point in
                        Text("• \(point)")
                    }
                    .padding(.bottom, 10)
                }

                // Tips Section
                Text("Tips")
                    .font(.headline)
                ForEach(topic.tips, id: \.self) { tip in
                    Text("• \(tip)")
                }
            }
            .padding()
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
