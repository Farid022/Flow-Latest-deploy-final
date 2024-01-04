//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import Foundation

class ThreadReplyViewModel: ObservableObject {
    
    func uploadThreadReply(toThread thread: Thread, replyText: String) async throws {
        try await ThreadService.replyToThread(thread, replyText: replyText)
    }
}
