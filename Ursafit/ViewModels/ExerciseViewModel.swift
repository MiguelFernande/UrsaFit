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
    @Published var searchQuery: String = "" // Used for filtering
    
    private let apiKey = "5vZTVMLGtfDqsjV50y9I9RcUKaTeYkIdNss2prKC"
    
    func fetchExercises() {
        // Set initial state on main thread
        Task { @MainActor in
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
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decodedExercises = try JSONDecoder().decode([Exercise].self, from: data)
                // Update UI state on main thread
                exercises = decodedExercises
                isLoading = false
            } catch {
                errorMessage = "Error: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    func filteredExercises() -> [Exercise] {
        if searchQuery.isEmpty {
            return exercises
        } else {
            return exercises.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
    }
}
