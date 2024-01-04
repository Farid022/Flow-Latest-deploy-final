//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import Foundation

enum ThreadActionSheetOptions {
    case unfollow
    case mute
    case hide
    case report
    case block
    
    var title: String {
        switch self {
        case .unfollow:
            return "Unfollow"
        case .mute:
            return "Mute"
        case .hide:
            return "Hide"
        case .report:
            return "Report"
        case .block:
            return "Block"
        }
    }
}
