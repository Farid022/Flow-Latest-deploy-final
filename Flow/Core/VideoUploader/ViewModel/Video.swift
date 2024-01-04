//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import Foundation

struct Video: Identifiable, Decodable {
    let videoUrl: String
    
    var id: String{
            return NSUUID().uuidString
        
    }
}

