//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import Foundation
import Firebase

class CreateThreadViewModel: ObservableObject {
    
    @Published var caption = ""
    
    func uploadThread() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let thread = Thread(
            ownerUid: uid,
            caption: caption,
            timestamp: Timestamp(),
            likes: 0,
            replyCount: 0
        )
        try await ThreadService.uploadThread(thread)
    }
}
