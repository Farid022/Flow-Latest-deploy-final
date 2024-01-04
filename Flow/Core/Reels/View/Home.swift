//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI
import PhotosUI
import AVKit
import Foundation
import Firebase
import FirebaseFirestoreSwift
import AppTrackingTransparency


struct Home: View {
    @StateObject var viewModel = ReelsContentViewModel()
    //var axis: Axis.Set
    
//    init(axis: Axis.Set) {
//        self.axis = axis
//    }
    
    
    
    var body: some View {
        ZStack {
            ReelsView(contentViewModel: viewModel)
               .tag("Reels")
        }
        .overlay(alignment: .topTrailing) {
            PhotosPicker(selection: $viewModel.selectedItem,
                         matching: .any(of: [.videos, .not(.images)])) {
                Image(systemName: "video.badge.plus")
                    .foregroundColor(.white)
                    .font(Font.system(size:23,weight: .bold))
            }
//            Image(systemName: "Flow-app-icon")
//                .foregroundColor(.white)
//                .font(Font.system(size:25,weight: .bold))
//                         .padding(.trailing,50)
//            Image("Flow-app-icon")
//                .renderingMode(.template)
//                .resizable()
//                .colorMultiply(Color.theme.primaryText)
//                .scaledToFit()
//                .frame(width: 40, height: 40)
//                .padding(.trailing,350)

            
        }
        .overlay {
            if viewModel.isLoading {
                RotatingDotAnimation()
            }
        }
        .onAppear {
            requestTrackingPermission()
        }
        

    }
    
    private func requestTrackingPermission() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // User granted permission, you can now track
                    print("Tracking authorized")
                case .denied:
                    // User denied permission, handle accordingly
                    print("Tracking denied")
                case .notDetermined:
                    // Tracking permission has not been requested yet
                    print("Tracking not determined")
                case .restricted:
                    // Tracking is restricted, e.g., due to parental controls
                    print("Tracking restricted")
                @unknown default:
                    break
                }
            }
            
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
