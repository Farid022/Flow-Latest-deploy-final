//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI

struct ExploreRowView: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                CircularProfileImageView(user: user, size: .small)
                
                VStack(alignment: .leading) {
                    Text(user.username)
                        .bold()
                    
                    Text(user.fullname)
                }
                .font(.footnote)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Follow")
                        .foregroundStyle(Color.theme.primaryText)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 100, height: 32)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        }
                }

            }
            .padding()
            
            Text("22k followers")
                .font(.subheadline)
                .padding(.leading, 66)
                
            
            Divider()
        }
    }
}

struct ExploreRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreRowView(user: dev.user)
    }
}
