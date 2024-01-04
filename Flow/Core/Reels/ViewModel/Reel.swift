//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI
import AVKit

struct Reel: Identifiable {

    var id = UUID().uuidString
    var reelIndex: Int?
    var player: AVPlayer?
    var mediaFile: MediaFile
}

