//
//  UserService.swift
//  Ursafit
//
//  Created by kiana berchini on 12/4/24.
//
import FirebaseFirestore
import FirebaseAuth

class UserService {
    private let db = Firestore.firestore()

    // Fetch all users (excluding the current user by username)
    func fetchUsers(excluding currentUsername: String, completion: @escaping ([Friend]) -> Void) {
        db.collection("users")
            .whereField("username", isNotEqualTo: currentUsername) // Exclude the current user by username
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                    completion([]) // Return an empty array if there's an error
                    return
                }

                let friends = snapshot?.documents.compactMap { document -> Friend? in
                    let data = document.data()
                    guard let username = data["username"] as? String else {
                        return nil // Only ensure username exists
                    }
                    return Friend(id: document.documentID, username: username) // Create Friend without profilePictureURL
                } ?? []

                completion(friends) // Return the friends list
            }
    }
}
