//
//  FreindsView.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 11/16/24.
//  Edited by Kiana Berchini on 12/2/24
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Friend: Identifiable {
    var id: String
    var username: String
}

struct FriendsView: View {
    @State private var friends: [Friend] = []
    @State private var searchText: String = ""
    @State private var searchResults: [Friend] = []
    @State private var isSearching = false
    
    var body: some View {
        VStack {
            // Search bar at the top
            FriendSearchBar(text: $searchText)
                .padding(.top) // Padding for the top
                .onChange(of: searchText) { _ in
                    searchUsers()
                }

            // Spacer to push content to the bottom of the screen
            Spacer()

            // Display results based on search
            if searchResults.isEmpty {
                Text(isSearching ? "No users found." : "No friends to display.")
                    .padding()
            } else {
                List(searchResults) { friend in
                    HStack {
                        Text(friend.username)
                            .font(.headline)
                        
                        // Friend request button
                        Button(action: {
                            sendFriendRequest(to: friend)
                        }) {
                            Text("Send Request")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchFriends()
        }
        .navigationTitle("Friends")
    }

    // Fetching all friends from Firestore
    func fetchFriends() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No user is signed in")
            return
        }

        let userService = UserService()
        userService.fetchUsers(excluding: currentUser.displayName ?? "") { users in
            print("Fetched users: \(users)") // Debugging print statement
            if users.isEmpty {
                print("No users found")
            } else {
                // Convert User objects to Friend objects
                let friendList = users.map { user -> Friend in
                    return Friend(id: user.id, username: user.username) // Directly use id as String
                }
                self.friends = friendList
                self.searchResults = friendList // Initially show all users
            }
        }
    }

    // Search function that filters friends based on the username
    func searchUsers() {
        isSearching = true
        if searchText.isEmpty {
            searchResults = friends
            isSearching = false
        } else {
            searchResults = friends.filter { friend in
                friend.username.lowercased().contains(searchText.lowercased())
            }
        }
    }

    // Function to send a friend request
    func sendFriendRequest(to friend: Friend) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No user is signed in")
            return
        }

        // Check if a request already exists
        Firestore.firestore().collection("friendRequests")
            .whereField("fromUserId", isEqualTo: currentUserId)
            .whereField("toUserId", isEqualTo: friend.id)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error checking existing requests: \(error.localizedDescription)")
                    return
                }

                if snapshot?.documents.isEmpty == true {
                    // No existing request, send a new one
                    let requestRef = Firestore.firestore().collection("friendRequests").document()
                    requestRef.setData([
                        "fromUserId": currentUserId,
                        "toUserId": friend.id,
                        "status": "pending"
                    ]) { error in
                        if let error = error {
                            print("Error sending friend request: \(error.localizedDescription)")
                        } else {
                            print("Friend request sent!")
                        }
                    }
                } else {
                    print("Friend request already sent.")
                }
            }
    }
}

// Search bar component (renamed to avoid conflict)
struct FriendSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        TextField("Search for friends...", text: $text)
            .padding(7)
            .padding(.horizontal, 32)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    Spacer()
                }
            )
            .padding(.horizontal)
            .frame(height: 50) // To ensure search bar height is consistent
    }
}
