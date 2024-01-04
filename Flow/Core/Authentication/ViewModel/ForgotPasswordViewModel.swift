//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import Foundation

@MainActor
class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var didSendEmail = false
    
    func sendPasswordResetEmail() async throws {
        try await AuthService.shared.sendPasswordResetEmail(toEmail: email)
        didSendEmail = true 
    }
}
