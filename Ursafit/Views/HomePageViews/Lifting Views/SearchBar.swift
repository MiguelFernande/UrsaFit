//
//  SearchBar.swift
//  Ursafit
//
//  Created by kiana berchini on 12/1/24.
//
import SwiftUI
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search exercises", text: $text)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
        }
    }
}
