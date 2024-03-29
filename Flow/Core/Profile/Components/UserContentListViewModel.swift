//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import Foundation

@MainActor
class UserContentListViewModel: ObservableObject {
    @Published var threads = [Thread]()
    @Published var replies = [ThreadReply]()
    
    private let user: User
    
    init(user: User) {
        self.user = user
        Task { try await fetchUserThreads() }
        Task { try await fetchUserReplies() }
    }
    
    func fetchUserThreads() async throws {
        print("DEBUG: Fetching user threads..")
        var userThreads = try await ThreadService.fetchUserThreads(uid: user.id)
        
        for i in 0 ..< userThreads.count {
            userThreads[i].user = self.user
        }
                
        self.threads = userThreads
    }
    
    func fetchUserReplies() async throws {
        self.replies = try await UserService.fetchThreadReplies(forUser: user)
        try await fetchReplyMetadta()
    }
    
    private func fetchReplyMetadta() async throws {
        await withThrowingTaskGroup(of: Void.self, body: { group in
            for reply in self.replies {
                group.addTask { try await self.fetchReplyThreadData(reply: reply) }
            }
        })
    }
    
    private func fetchReplyThreadData(reply: ThreadReply) async throws {
        guard let replyIndex = replies.firstIndex(where: { $0.id == reply.id }) else { return }
        
        async let thread = try await ThreadService.fetchThread(threadId: reply.threadId)
        
        let threadOwnerUid = try await thread.ownerUid
        async let user = try await UserService.fetchUser(withUid: threadOwnerUid)
        
        var threadCopy = try await thread
        threadCopy.user = try await user
        replies[replyIndex].thread = threadCopy
    }
}
