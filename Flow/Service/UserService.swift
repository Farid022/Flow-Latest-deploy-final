//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserService {
    
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }
    
    static func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        return user
    }
    
    static func fetchUsers() async throws -> [User] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await FirestoreConstants.UserCollection.getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        return users.filter({ $0.id != uid })
    }
}

// MARK: - Replies

extension UserService {
    static func fetchThreadReplies(forUser user: User) async throws -> [ThreadReply] {
       let snapshot = try await  FirestoreConstants
            .RepliesCollection
            .whereField("threadReplyOwnerUid", isEqualTo: user.id)
            .getDocuments()
        
        var replies = snapshot.documents.compactMap({ try? $0.data(as: ThreadReply.self) })
        
        for i in 0 ..< replies.count {
            replies[i].replyUser = user
        }
        
        return replies
    }
}

// MARK: - Following

extension UserService {
    static func follow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirestoreConstants
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .setData([:])
        
        async let _ = try await FirestoreConstants
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .document(currentUid)
            .setData([:])
        
        ActivityService.uploadNotification(toUid: uid, type: .follow)
        
        async let _ = try await updateUserFeedAfterFollow(followedUid: uid)
    }
    
    static func unfollow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirestoreConstants
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .delete()

        async let _ = try await FirestoreConstants
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .document(currentUid)
            .delete()
        
        async let _ = try await ActivityService.deleteNotification(toUid: uid, type: .follow)
        async let _ = try await updateUserFeedAfterUnfollow(unfollowedUid: uid)
    }
    
    static func checkIfUserIsFollowed(uid: String) async -> Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        let collection = FirestoreConstants.FollowingCollection.document(currentUid).collection("user-following")
        guard let snapshot = try? await collection.document(uid).getDocument() else { return false }
        return snapshot.exists
    }
    
    static func fetchUserStats(uid: String) async throws -> UserStats {        
        async let followingSnapshot = try await FirestoreConstants.FollowingCollection.document(uid).collection("user-following").getDocuments()
        let following = try await followingSnapshot.count
        
        async let followerSnapshot = try await FirestoreConstants.FollowersCollection.document(uid).collection("user-followers").getDocuments()
        let followers = try await followerSnapshot.count
        
        async let threadsSnapshot = try await FirestoreConstants.ThreadsCollection.whereField("ownerUid", isEqualTo: uid).getDocuments()
        let threadsCount = try await threadsSnapshot.count
        
        return .init(followersCount: followers, followingCount: following, threadsCount: threadsCount)
    }
        
    static func fetchUserFollowers(uid: String) async throws -> [User] {
        let snapshot = try await FirestoreConstants.FollowersCollection.document(uid).collection("user-followers").getDocuments()
        return try await fetchUsers(snapshot)

    }
    static func fetchUserFollowing(uid: String) async throws -> [User] {
        let snapshot = try await FirestoreConstants.FollowingCollection.document(uid).collection("user-following").getDocuments()
        return try await fetchUsers(snapshot)
    }
}

// MARK: Feed Updates

extension UserService {
    static func updateUserFeedAfterFollow(followedUid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let threadsSnapshot = try await FirestoreConstants.ThreadsCollection.whereField("ownerUid", isEqualTo: followedUid).getDocuments()
        
        for document in threadsSnapshot.documents {
            try await FirestoreConstants
                .UserCollection
                .document(currentUid)
                .collection("user-feed")
                .document(document.documentID)
                .setData([:])
        }
    }
    
    static func updateUserFeedAfterUnfollow(unfollowedUid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let threadsSnapshot = try await FirestoreConstants.ThreadsCollection.whereField("ownerUid", isEqualTo: unfollowedUid).getDocuments()
        
        for document in threadsSnapshot.documents {
            try await FirestoreConstants
                .UserCollection
                .document(currentUid)
                .collection("user-feed")
                .document(document.documentID)
                .delete()
        }
    }
}

extension UserService {
    private static func fetchUsers(_ snapshot: QuerySnapshot?) async throws -> [User] {
        var users = [User]()
        guard let documents = snapshot?.documents else { return [] }
        
        for doc in documents {
            let user = try await UserService.fetchUser(withUid: doc.documentID)
            users.append(user)
        }
        
        return users
    }
}
