//
//  NutritionTopicsView.swift
//  Ursafit
//
//  Created by Corey Buckingham on 11/16/24.
//

import SwiftUI

struct NutritionTopicsView: View {
    @StateObject private var viewModel = NutritionTopicsViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.topics) { topic in
                NavigationLink(destination: NutritionDetailView(topic: topic)) {
                    Text(topic.title)
                }
            }
            .navigationTitle("Nutrition Topics")
        }
    }
}
