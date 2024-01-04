//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel = ExploreViewModel()
//    private let config: SearchViewModelConfig
    @State private var searchText = ""
    
//    init(config: SearchViewModelConfig) {
//        self.config = config
//        self._viewModel = StateObject(wrappedValue: SearchViewModel(config: config))
//    }
    
    var users: [User] {
        return searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(users) { user in
                    NavigationLink(value: user) {
                        UserCell(user: user)
                            .padding(.leading)
                            .onAppear {
                                if user.id == users.last?.id ?? "" {
                                }
                            }
                    }
                }
                
            }
            .navigationTitle("Search")
            .padding(.top)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
