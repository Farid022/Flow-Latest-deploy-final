//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI

// Sample Model And Reels Videos...
struct MediaFile: Identifiable{
    var id = UUID().uuidString
    var url: String
    var title: String
    var isExpanded: Bool = false
}


