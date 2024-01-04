//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestoreSwift


class ReelsContentViewModel: ObservableObject {
    @Published var videos = [Video]()
    @Published var isLoading = false
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await uploadVideo() } }
    }
    
    init() {
        Task { try await fetchVideos() }
    }
    
    func uploadVideo() async throws {
        guard let item = selectedItem else { return }
        guard let videoData = try await item.loadTransferable(type: Data.self) else { return }
        
        guard let videoUrl = try await VideoUploader.uploadVideo(withData: videoData) else { return }
        
        
        try await Firestore.firestore().collection("videos").document().setData(["videoUrl": videoUrl])
        
        Task { try await fetchVideos() }
        
        print("DEBUG: Finished video upload..")
    }
    
    @MainActor
    func fetchVideos() async throws {
        self.isLoading = true
        let snapshot = try await Firestore.firestore().collection("videos").getDocuments()
        self.videos = snapshot.documents.compactMap({ try? $0.data(as: Video.self) })
        self.isLoading = false
        }
    }

