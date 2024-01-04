//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    var thread = Thread(
        ownerUid: NSUUID().uuidString,
        caption: "Here's to the crazy ones. The misfits. The rebels",
        timestamp: Timestamp(),
        likes: 247,
        imageUrl: "lewis-hamilton",
        replyCount: 67,
        user: User(
            fullname: "Lewis Hamilton",
            email: "lewis-hamilton@gmail.com",
            username: "lewis-hamilton",
            profileImageUrl: nil
        )
    )
    
    var user = User(
        fullname: "Daniel Ricciardo",
        email: "daniel@gmail.com",
        username: "daniel-ricciardo",
        profileImageUrl: nil
    )
    
    lazy var activityModel = ActivityModel(
        type: .like,
        senderUid: NSUUID().uuidString,
        timestamp: Timestamp(),
        user: self.user
    )
    
    lazy var reply = ThreadReply(
        threadId: NSUUID().uuidString,
        replyText: "This is a test reply for preview purposes",
        threadReplyOwnerUid: NSUUID().uuidString,
        threadOwnerUid: NSUUID().uuidString,
        timestamp: Timestamp(),
        thread: thread,
        replyUser: user
    )
}
