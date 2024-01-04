//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI
import WebKit
import Foundation
import AuthenticationServices

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var isPresentWebView = false
    @State private var selectedDate = Date()
    @Environment(\.colorScheme) var colorScheme
    @State var hidden = false

        

    struct WebView: UIViewRepresentable {
        // 1
        let url: URL

        
        // 2
        func makeUIView(context: Context) -> WKWebView {

            return WKWebView()
        }
        
        // 3
        func updateUIView(_ webView: WKWebView, context: Context) {

            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let start = DateComponents(year: 2020, month: 2, day: 1)
        let end = DateComponents(year: 2022, month: 2, day: 1)
        return calendar.date(from: start)! ... calendar.date(from: end)!
    }
    var body: some View {
       
        VStack {
            
            Spacer()
            
            // logo image
            Image("Flow-app-icon")
                .renderingMode(.template)
                .resizable()
                .colorMultiply(Color.theme.primaryText)
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding()
            
            // text fields
            VStack(spacing: 10){
                Text("Lets Register\nAccount")
                    .font(.largeTitle.bold())
//                    .hAlign(.leading)
                
//                Text("Hello user, have a wonderful journey")
//                    .font(.title3)
//                    .hAlign(.leading)
                
                VStack {
//                    SignInWithAppleButton(.signUp) { request in
//                        
//                        request.requestedScopes = [.email, .fullName]
//                        
//                    } onCompletion: { result in
//                        switch result {
//                        case .success(let auth):
//                            
//                            switch auth.credential {
//                                //                                case let authAppleCredential as
//                                //                            ASAuthorizationAppleIDCredential:
//                                //                                let email = credential.email
//                                //                                let fullName = credential.fullName
//                                //                                let userID = credential.user
//                            default:
//                                break
//                            }
//                        case .failure(let error):
//                            print(error)
//                        }
//                    }
//                    .signInWithAppleButtonStyle(
//                        colorScheme == .dark ? .white : .black
//                    )
//                    .frame(height: 50)
//                    .padding()
//                    .cornerRadius(8)
                }
                
                TextField("Enter your username", text: $viewModel.username)
                                    .autocapitalization(.none)
                                    .modifier(ThreadsTextFieldModifier())
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(ThreadsTextFieldModifier())
                
                
                ZStack {
                    Group {
                        if self.hidden{
                            TextField("Password", text: $viewModel.password)
                                .modifier(ThreadsTextFieldModifier())
                            
//                                .offset(x: 100, y: 0)
                            
                        } else {
                            
                SecureField("Password", text: $viewModel.password)
                    .modifier(ThreadsTextFieldModifier())
                    .offset(x: 0, y: 0)
            }
            
            Button(action: {
                self.hidden.toggle()
            }) {
                Image(systemName: self.hidden ? "eye.fill": "eye.slash")
                    .foregroundColor((self.hidden == true ) ?
                                     Color.green : Color.secondary)
            }.offset(x: 100, y: 0)
        }
        }
                            
                TextField("Full name", text: $viewModel.fullname)
                    .autocapitalization(.none)
                    .modifier(ThreadsTextFieldModifier())
                                
//                TextField("Enter your Phone Number", text: $viewModel.username)
//                    .autocapitalization(.none)
//                    .modifier(ThreadsTextFieldModifier())
            }
            
            SwiftUI.Button {
                Task { try await viewModel.createUser() }
            } label: {
                Text("Sign Up")
                    .foregroundColor(Color.theme.primaryBackground)
                    .modifier(ThreadsButtonModifier())
                    
            }
            
//            DatePicker(
//                            "Enter your birthdate",
//                            selection: $selectedDate,
//                            //in: ...Date(),
//                            in: dateRange,
//                            displayedComponents: [.date]
//                        )
//                        .datePickerStyle(.compact)
//
//                        DatePicker(selection: $selectedDate) {
//                            Label("Select Your birth date", systemImage: "calendar")
//                        }
                    }

            .padding(.vertical)
            
            
            
            Spacer()
                            Text("By continuing you accept our")
                            .foregroundColor(.gray)
                            Button("Terms and Privacy Policy")
//                            Text("and acknowledge that you understand how we collect, use, and share your data.")

        {
                    isPresentWebView = true

                    }
        
        .sheet(isPresented: $isPresentWebView) {
                        NavigationStack {
                            WebView(url: URL(string: "https://flow-b2f0b.web.app/about.html")!)

                                .ignoresSafeArea()
                                .navigationTitle("Flow")
                                .navigationBarTitleDisplayMode(.inline)
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.black)
//                    }
                    }
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    
                    Text("Sign In")
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color.theme.primaryText)
                .font(.footnote)
            }
            .padding(.vertical, 16)
        }
    }

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
