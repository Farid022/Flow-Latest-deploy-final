//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI
import AVKit

struct ReelsView: View {
    @ObservedObject var contentViewModel: ReelsContentViewModel
    @State var currentReel = ""
    @State var reels: [Reel] = []
    @State private var offsetY: CGFloat = 0
    @State private var tabState: Visibility = .visible
    
    var body: some View {
        // Setting Width and height for rotated view....
        GeometryReader { proxy in
            
            let size = proxy.size
            
            // Vertical Page Tab VIew....
            TabView(selection: $currentReel) {
                
                ForEach($reels) { $reel in
                    ReelsPlayer(reel: $reel, currentReel: $currentReel)
                    // setting width...
                        .frame(width: size.width)
                    // Rotating Content...
                        .rotationEffect(.init(degrees: -90))
                        .ignoresSafeArea(.all, edges: .bottom)
                        .ignoresSafeArea(.all, edges: .top)
                        .tag(reel.id)
                }
            }
            // Rotating View....
            .rotationEffect(.init(degrees: 90))
            // Since view is rotated setting height as width...
            .frame(width: size.height)
            .tabViewStyle(.page(indexDisplayMode: .never))
            // setting max width...
            .frame(width: size.width)
            
        }
        .background {
            CustomGesture {
                handleTabState($0)
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .ignoresSafeArea(.all, edges: .top)
        //.background(Color.clear.ignoresSafeArea())
        // setting intial reel...
        .onAppear {
            currentReel = reels.first?.id ?? ""
        }
        .onReceive(contentViewModel.$videos) { videos in
            self.reels = videos.enumerated().map { (i, video) in
                let player = AVPlayer(url: URL(string: video.videoUrl)!)
                return Reel(reelIndex: i, player: player, mediaFile: MediaFile(url: video.videoUrl, title: ""))
            }
        }
        .toolbarBackground(.clear, for: .tabBar)
        .toolbar(tabState, for: .tabBar)
    }
    
    private func handleTabState(_ gesture: UIPanGestureRecognizer) {
        let offsetY = gesture.translation(in: gesture.view).y
        let velocityY = gesture.velocity(in: gesture.view).y
        
        if velocityY < 0 {
            if -(velocityY / 5) > 60 && tabState == .visible {
                tabState = .hidden
            }
        } else {
            if (velocityY / 5) > 40 && tabState == .hidden {
                tabState = .visible
            }
        }
        print("Y IS \(offsetY)")
    }
}

struct ReelsPlayer: View {
    
    @Binding var reel: Reel
    @Binding var currentReel: String
    // Expanding title if its clicked...
    @State var showMore = false
    
    @State var isMuted = false
    @State var volumeAnimation = false
    
    var body: some View {
        
        ZStack {
            
            // safe Check...
            if let player = reel.player {
                CustomVideoPlayer(player: player)
                // Playing Video Based on Offset...
                
                GeometryReader { proxy -> Color in
                        let minY = proxy.frame(in: .global).minY

                        let size = proxy.size

                        DispatchQueue.main.async {
                            // since we have many cards and offset goes beyond
                            // so it starts playing the below videos...
                            // to avoid this checking the current one with current reel id.....
                            if -minY < (size.height / 2) && minY < (size.height / 2) && currentReel == reel.id{
                                player.play()
                            }
                            else {
                                player.pause()
                            }
                        }
                    return Color.clear
                }
                
                
                // Volume COntrol....
                // allowing control for set of area...
                // its your wish...
                Color.black
                    .opacity(0.01)
                    .frame(width: 150, height: 150)
                    .onTapGesture {
                        if volumeAnimation{
                            return
                        }
                        
                        isMuted.toggle()
                        // Muting player...
                        player.isMuted = isMuted
                        withAnimation{volumeAnimation.toggle()}
                        
                        // Closing animation after 0.8 sec...
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            
                            withAnimation{volumeAnimation.toggle()}
                        }
                    }
                
                // Dimming background when showing more content...
                Color.black.opacity(showMore ? 0.35 : 0)
                    .onTapGesture {
                        // closing it...
                        withAnimation{showMore.toggle()
                            
                        }
                    }
                
                VStack{
                    
                    HStack(alignment: .bottom){
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            HStack(spacing: 15){
                                
                                
//                                Image(systemName: "arrowshape.turn.up.right.fill")
//                                .font(.title)
//                                .foregroundColor(.white)
//                                Image("profile")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 35, height: 35)
//                                    .clipShape(Circle())
//
//                                Text("iJustine")
//                                    .font(.callout.bold())
                                
                                Button {
                                    
                                } label: {
//                                    Text("Follow")
//                                        .font(.caption.bold())
                                }
                                
                            }
                            
                            // Title Custom View...
                            
                            ZStack{
                                
                                if showMore{
                                    
                                    ScrollView(.vertical, showsIndicators: false) {
                                        
                                        // your extra text...
//                                        Text(reel.mediaFile.title + sampleText)
//                                            .font(.callout)
//                                            .fontWeight(.semibold)
                                    }
                                    .frame(height: 120)
                                    .onTapGesture {
                                        withAnimation{showMore.toggle()}
                                    }
                                }
                                else{
                                    
                                    Button {
                                        
                                        withAnimation{showMore.toggle()}
                                        
                                    } label: {
                                        
                                        HStack{
                                            
                                            
//                                            Text(reel.mediaFile.title)
//                                                .font(.callout)
//                                                .fontWeight(.semibold)
//                                                .lineLimit(1)
//
//                                            Text("more")
//                                                .font(.callout.bold())
//                                                .foregroundColor(.gray)
                                        }
                                        .padding(.top,6)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                }
                            }
                        }
                        
                        Spacer(minLength: 20)
                        
                        // List of Buttons....
                        
                        ActionButtons(reel: reel)
                    }
                    
                    // Music View...
                    HStack{
                        
//                        Text("A Sky full of Stars")
//                            .font(.caption)
//                            .fontWeight(.semibold)
//
//                        Spacer(minLength: 20)
//
//                        Image("album")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 30, height: 30)
//                            .cornerRadius(6)
//                            .background(
//
//                                RoundedRectangle(cornerRadius: 6)
//                                    .stroke(Color.white,lineWidth: 3)
//                            )
//                            .offset(x: -5)
                    }
                    .padding(.top,10)
                }
                .padding(.horizontal)
                .padding(.bottom,20)
                .foregroundColor(.white)
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(.secondary)
                    .clipShape(Circle())
                    .foregroundStyle(.black)
                    .opacity(volumeAnimation ? 1 : 0)
            }
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}


struct ActionButtons: View {
    @State private var showingSheet = false
    var reel: Reel
    
    var body: some View{
        
        VStack(spacing: 25){
            
            Button {
                
            } label: {
                VStack(spacing: 10){
                    
//                    Image(systemName: "suit.heart")
//                        .font(.title)
//
//                    Text("233K")
//                        .font(.caption.bold())
                }
            }
            
            Button {
                showingSheet.toggle()
            } label: {
                VStack(spacing: 10){
                    
//                    Image(systemName: "bubble.right")
//                        .font(.title)
//
//                    Text("120")
//                        .font(.caption.bold())
                }
            }.sheet(isPresented: $showingSheet) {
                FeedView()
            }
            
            Button {
                
            } label: {
//                VStack(spacing: 10){
//
//                    Image(systemName: "paperplane")
//                        .font(.title)
//                }
            }
            
            Button {
                
            } label: {
//                Image("menu")
//                    .resizable()
//                    .renderingMode(.template)
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 20, height: 20)
//                // rotating...
//                    .rotationEffect(.init(degrees: 90))
            }
            
            
        }
    }
}


let sampleText = "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available."

fileprivate struct CustomGesture: UIViewRepresentable {
    var onChange: (UIPanGestureRecognizer) -> ()
    
    private let gestureID = "AB443CB7-84D3-4F46-A27D-8555D5B352EE"
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onChange: onChange)
    }
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let superview = uiView.superview?.superview, !(superview.gestureRecognizers?.contains(where: {$0.name == gestureID}) ?? false ) {
                    let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.gestureChange(gesture:)))
                    gesture.name = gestureID
                    gesture.delegate = context.coordinator
                    superview.addGestureRecognizer(gesture)
                }
            }
        }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onChange: (UIPanGestureRecognizer) -> ()
        init(onChange: @escaping (UIPanGestureRecognizer) -> Void) {
            self.onChange = onChange
        }
        
        @objc func gestureChange(gesture: UIPanGestureRecognizer) {
            onChange(gesture)
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}
