//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import FirebaseFirestoreSwift
import Firebase
import Foundation

struct User: Identifiable, Codable {
    @DocumentID var uid: String?
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: String?
    var bio: String?
    var link: String?
    var stats: UserStats?
    var isFollowed: Bool?
    
    var id: String {
        return uid ?? NSUUID().uuidString
    }
    
    var isCurrentUser: Bool {
        return id == Auth.auth().currentUser?.uid
    }
}

struct UserStats: Codable {
    var followersCount: Int
    var followingCount: Int
    var threadsCount: Int
}

extension User: Hashable {
    var identifier: String { return id }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
