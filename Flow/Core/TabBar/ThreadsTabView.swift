//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI

struct ThreadsTabView: View {
    @State private var selectedTab = 0
    @State var isTabbarVisible: Visibility = .visible
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Home()
                .tabItem {
                Spacer()
                           
                Image(systemName: "play.rectangle" )
                    .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                   
            }
            .onAppear { selectedTab = 0 }
            .tag(0)
            
//            FeedView()
//                .tabItem {
//                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
//                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
//                }
//                .onAppear { selectedTab = 0 }
//                .tag(1)
//            
//            ExploreView()
//                .tabItem { Image(systemName: "magnifyingglass")
//                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
//
//                }
//                .onAppear { selectedTab = 1 }
//                .tag(2)
//            
//            CreateThreadDummyView(tabIndex: $selectedTab)
//                .tabItem { Image(systemName: "plus")
//                        .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
//
//                }
//                .onAppear { selectedTab = 2 }
//                .tag(3)
//
//            
//            
//            ActivityView(threadTabView: self)
//                .tabItem {
//                    Image(systemName: selectedTab == 3 ? "heart.fill" : "heart")
//                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
//                }
//                .onAppear { selectedTab = 3 }
//                .tag(4)
//                .toolbar(isTabbarVisible, for: .tabBar)
//            
           
            CurrentUserProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 5 ? "person.crop.rectangle" : "person.crop.rectangle.fill")
                        .environment(\.symbolVariants, selectedTab == 5 ? .fill : .none)
                }
                .onAppear { selectedTab = 5 }
                .tag(5)
        }
        .tint(Color.theme.primaryText)
        
    }
}

struct ThreadsTabView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadsTabView()
    }
}
