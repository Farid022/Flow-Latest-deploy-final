//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import Foundation

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var users = [User]()
    
    init() {
        Task { try await fetchUsers() }
    }
    
    func fetchUsers() async throws {
        self.users = try await UserService.fetchUsers()
    }
    
    func filteredUsers(_ query: String) -> [User] {
            let lowercasedQuery = query.lowercased()
            return users.filter({
                $0.fullname.lowercased().contains(lowercasedQuery) ||
                $0.username.contains(lowercasedQuery)
            })
        }
}
