//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import Foundation
import Combine
import SwiftUI
import PhotosUI
import Firebase

@MainActor
class CurrentUserProfileViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var currentUser: User?
    @Published var threads = [Thread]()
    @Published var replies = [ThreadReply]()
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    @Published var profileImage: Image?
    @Published var bio = ""
    @Published var link = ""
    
    private var uiImage: UIImage?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
        
    init() {
        setupSubcribers()
        loadUserData()
    }
}

// MARK: - User Data

extension CurrentUserProfileViewModel {
    func loadUserData() {
        self.bio = currentUser?.bio ?? ""
        
        Task {
            self.currentUser?.stats = try await UserService.fetchUserStats(uid: currentUser?.id ?? "")
        }
    }
    
    func updateUserData() async throws {
        guard let user = currentUser else { return }
        var data: [String: String] = [:]
        
        if !bio.isEmpty, user.bio ?? "" != bio {
            currentUser?.bio = bio
            data["bio"] = bio
        }
        
        if !link.isEmpty, currentUser?.link ?? "" != link {
            currentUser?.link = link
            data["link"] = link
        }
        
        if let uiImage = uiImage {
            try await updateProfileImage(uiImage)
            data["profileImageUrl"] = currentUser?.profileImageUrl
        }
        
        try await FirestoreConstants.UserCollection.document(user.id).updateData(data)
    }
}

// MARK: - Subscribers

extension CurrentUserProfileViewModel {
    private func setupSubcribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
}

// MARK: - Image Loading

extension CurrentUserProfileViewModel {
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func updateProfileImage(_ uiImage: UIImage) async throws {
        let imageUrl = try? await ImageUploader.uploadImage(image: uiImage, type: .profile)
        currentUser?.profileImageUrl = imageUrl
    }
}
