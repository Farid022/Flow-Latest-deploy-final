//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
//            ForEach(SettingsOptions.allCases) { option in
//                HStack {
//                    Image(systemName: option.imageName)
//                    
//                    Text(option.title)
//                        .font(.subheadline)
//                }
//            }
            
            VStack(alignment: .leading) {
                
                Divider()
                Button("Flow Premium") {
//                    AuthService.shared.deleteAccount()
                }
                
                Divider()

                Button("Friends") {
//                    AuthService.shared.deleteAccount()
                }
                
                Divider()
                
                Button("Delete Account") {
                    AuthService.shared.deleteAccount()
                }
                
                Divider()

                Button("Log Out") {
                    AuthService.shared.signOut()
                }
//                Button("Delete Account",role: .destructive,action: deleteAccount)
//            } label: {
               

            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}
