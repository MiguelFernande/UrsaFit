//
//  Exercise.swift
//  Ursafit
//
//  Created by kiana berchini on 11/17/24.
//

import Foundation

struct Exercise: Codable, Identifiable {
    var id: String { name }
    var name: String
    var type: String
    var muscle: String?
    var equipment: String?
    var difficulty: String?
    var instructions: String
}

typealias ExerciseResponse = [Exercise]
