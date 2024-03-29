//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI
struct RotatingDotAnimation: View {

    @State private var startAnimation = false
    @State private var duration = 1.0 // Works as speed, since it repeats forever

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 150, height: 150, alignment: .center)

            Circle()
                .fill(.white)
                .frame(width: 18, height: 18, alignment: .center)
                .offset(x: -63)
                .rotationEffect(.degrees(startAnimation ? 360 : 0))
                .animation(.easeInOut(duration: duration).repeatForever(autoreverses: false),
                           value: startAnimation
                )
        }
        .onAppear {
            self.startAnimation.toggle()
        }
    }
}

