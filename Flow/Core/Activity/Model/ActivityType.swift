//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import Foundation

enum ActivityType: Int, CaseIterable, Identifiable, Codable {
    case like
    case reply
    case follow
    
    var id: Int { return self.rawValue }
}
