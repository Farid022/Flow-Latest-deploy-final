//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import Foundation

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var threads = [Thread]()
    @Published var replies = [ThreadReply]()
    @Published var user: User
    
    init(user: User) {
        self.user = user
        loadUserData()
    }
        
    func loadUserData() {
        Task {
            async let stats = try await UserService.fetchUserStats(uid: user.id)
            self.user.stats = try await stats
            
            async let isFollowed = await checkIfUserIsFollowed()
            self.user.isFollowed = await isFollowed
        }
    }
}

// MARK: - Following

extension UserProfileViewModel {
    func follow() async throws {
        try await UserService.follow(uid: user.id)
        self.user.isFollowed = true
        self.user.stats?.followersCount += 1
    }
    
    func unfollow() async throws {
        try await UserService.unfollow(uid: user.id)
        self.user.isFollowed = false
        self.user.stats?.followersCount -= 1
    }
    
    func checkIfUserIsFollowed() async -> Bool {
        return await UserService.checkIfUserIsFollowed(uid: user.id)
    }
}
