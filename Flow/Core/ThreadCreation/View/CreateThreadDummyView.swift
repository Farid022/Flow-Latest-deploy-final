//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI

struct CreateThreadDummyView: View {
    @State private var presented = false
    @Binding var tabIndex: Int
    
    var body: some View {
        VStack { }
        .onAppear { presented = true }
        .sheet(isPresented: $presented) {
            CreateThreadView(tabIndex: $tabIndex)
        }
    }
}

struct CreateThreadDummyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateThreadDummyView(tabIndex: .constant(0))
    }
}
