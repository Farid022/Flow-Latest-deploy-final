//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import Combine
import FirebaseAuth
import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestoreSwift


class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
//    @Published var videos = [Video]()
    @Published var isLoading = false
    @Published var selectedItem: PhotosPickerItem?
    
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthService.shared.$userSession.sink { [weak self] session in
            self?.userSession = session
        }.store(in: &cancellables)
        
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
}
