//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI

struct ProfileView: View {
    @State private var selectedThreadFilter: ProfileThreadFilterViewModel = .threads
    @State private var showEditProfile = false 
    @StateObject var viewModel: UserProfileViewModel
    @State private var showUserRelationSheet = false
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: UserProfileViewModel(user: user))
    }
    
    private var isFollowed: Bool {
        return viewModel.user.isFollowed ?? false
    }
    
    private var user: User {
        return viewModel.user
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullname)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(user.username)
                                .font(.subheadline)
                        }
                        
                        if let bio = user.bio {
                            Text(bio)
                                .font(.footnote)
                        }
                        
                        Button {
                            showUserRelationSheet.toggle()
                        } label: {
                            Text("\(user.stats?.followersCount ?? 0) followers")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }

                    }
                    
                    Spacer()
                    
                    CircularProfileImageView(user: user, size: .medium)
                }
                
                if user.isCurrentUser {
                    Button {
                        showEditProfile.toggle()
                    } label: {
                        Text("Edit Profile")
                            .foregroundStyle(Color.theme.primaryText)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 175, height: 32)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                    }
                } else {
                    Button {
                        handleFollowTapped()
                    } label: {
                        Text(isFollowed ? "Following" : "Follow")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(isFollowed ? Color.theme.primaryText : Color.theme.primaryBackground)
                            .frame(width: 352, height: 32)
                            .background(isFollowed ? Color.theme.primaryBackground : Color.theme.primaryText)
                            .cornerRadius(8)
                            .overlay {
                                if isFollowed {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                }
                            }
                    }
                }
                
                UserContentListView(
                    selectedFilter: $selectedThreadFilter,
                    user: user
                )
            }
            .sheet(isPresented: $showUserRelationSheet) {
                UserRelationsView(user: user)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
    }
    
    func handleFollowTapped() {
        Task {
            if isFollowed {
                try await viewModel.unfollow()
            } else {
                try await viewModel.follow()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}
