//
//  ExerciseViewModel.swift
//  Ursafit
//
//  Created by kiana berchini on 11/12/24.
//

import Foundation

class ExerciseViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiKey = "***********"
    
    func fetchExercises() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://api.api-ninjas.com/v1/exercises") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    self?.isLoading = false
                    return
                }
                
                do {
                    let decodedExercises = try JSONDecoder().decode(ExerciseResponse.self, from: data)
                    self?.exercises = decodedExercises
                    self?.isLoading = false
                } catch {
                    self?.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    self?.isLoading = false
                }
            }
        }.resume()
    }
}
