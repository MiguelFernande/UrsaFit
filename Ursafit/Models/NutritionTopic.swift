//
//  NutritionTopic.swift
//  Ursafit
//
//  Created by Corey Buckingham on 11/16/24.
//

import Foundation

struct NutritionTopic: Identifiable {
    let id = UUID()
    let title: String
    let details: String
    let keyPoints: [String]?
    let tips: [String]
    
}
