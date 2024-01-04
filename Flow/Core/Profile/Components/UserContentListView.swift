//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI

struct UserContentListView: View {
    @Binding var selectedFilter: ProfileThreadFilterViewModel
    @StateObject var viewModel: UserContentListViewModel
    @Namespace var animation
    
    init(selectedFilter: Binding<ProfileThreadFilterViewModel>, user: User) {
        self._selectedFilter = selectedFilter
        self._viewModel = StateObject(wrappedValue: UserContentListViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(ProfileThreadFilterViewModel.allCases) { option in
                    VStack {
                        Text(option.title)
                        
                        if selectedFilter == option {
                            Rectangle()
                                .foregroundStyle(Color.theme.primaryText)
                                .frame(width: 180, height: 1)
                                .matchedGeometryEffect(id: "item", in: animation)
                        } else {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(width: 180, height: 1)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedFilter = option
                        }
                    }
                }
            }
            
            LazyVStack {
                if selectedFilter == .threads {
                    ForEach(viewModel.threads) { thread in
                        FeedCell(config: .thread(thread))
                    }
                    .transition(.move(edge: .leading))
                } else {
                    ForEach(viewModel.replies) { reply in
                        ThreadReplyCell(reply: reply)
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct UserContentListView_Previews: PreviewProvider {
    static var previews: some View {
        UserContentListView(
            selectedFilter: .constant(.threads),
            user: dev.user
        )
    }
}
