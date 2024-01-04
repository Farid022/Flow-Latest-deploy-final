//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI

struct ActivityView: View {
    var threadTabView:ThreadsTabView
    @StateObject var viewModel = ActivityViewModel()
    
    @State var offset: CGFloat = 0
    @State var lastOffset:CGFloat = 0
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    VStack {
                        ScrollView {
                            ActivityFilterView(selectedFilter: $viewModel.selectedFilter)
                                .padding(.vertical)
                            
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.notifications) { activityModel in
                                    if activityModel.type != .follow {
                                        NavigationLink(value: activityModel) {
                                            ActivityRowView(model: activityModel)
                                        }
                                    } else {
                                        NavigationLink(value: activityModel.user) {
                                            ActivityRowView(model: activityModel)
                                        }
                                    }
                                }
                            }
                        }
                        .overlay(
                            GeometryReader{ proxy -> Color in
                                let minY = proxy.frame(in: .named("SCROLL")).minY
                                let durationOffset:CGFloat = 35
                                
                                DispatchQueue.main.async{
                                    if minY < offset {
                                        if offset<0 && -minY>(lastOffset + durationOffset){
                                            
                                            threadTabView.isTabbarVisible = .hidden
                                        }
                                        lastOffset = -offset
                                    }
                                    if minY > offset && -minY < (lastOffset - durationOffset){
                                        threadTabView.isTabbarVisible = .visible
                                        lastOffset = -offset
                                    }
                                    self.offset = minY
                                }
                                return Color.clear
                            }
                        )
                    }
                    .navigationTitle("Activity")
                    .navigationDestination(for: ActivityModel.self, destination: { model in
                        if let thread = model.thread {
                            ThreadDetailsView(thread: thread)
                        }
                    })
                    .navigationDestination(for: User.self, destination: { user in
                        ProfileView(user: user)
                    })
                }
            }
        }
    }
}

//struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView(threadTabView: self)
//    }
//}
