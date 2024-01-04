//  Video.swift
//  SwiftUIVideoFeedTutorial2
//  Created by Herbert Perryman on 8/10/23

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State var hidden = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10){
                
                Spacer()
                
                // logo image
                Image("Flow-app-icon")
                    .renderingMode(.template)
                    .resizable()
                    .colorMultiply(Color.theme.primaryText)
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding()
                // ^^^^^^^^^
                
                
                //                Text("Login to Flow")
                //                    .font(.largeTitle.bold())
                //                //                    .hAlign(.leading)
                //                // ^^^^^^^^^
                //
                //
                //                Text("Welcome Back,\nExplore new creators")
                //                    .font(.title3)
                //                    .hAlign(.leading)
                // ^^^^^^^^^
                
                // text fields
                
                VStack {
                    //                    SignInWithAppleButton(.signIn) { request in
                    //
                    //                        request.requestedScopes = [.email, .fullName]
                    //
                    //                    } onCompletion: { result in
                    //                        switch result {
                    //                        case .success(let auth):
                    //
                    //                            switch auth.credential {
                                                    //                                case let authAppleCredential as
                                                    //                            ASAuthorizationAppleIDCredential:
                                                    //                                let email = credential.email
                                                    //                                let fullName = credential.fullName
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
                    
                    TextField("Enter your email", text: $viewModel.email)
                    //                        .autocapitalization(.none)
                        .modifier(ThreadsTextFieldModifier())
                    
                    ZStack {
                        Group {
                            if self.hidden{
                                TextField("Enter your password", text: $viewModel.password)
                                    .modifier(ThreadsTextFieldModifier())
                                
//                                    .offset(x: 100, y: 0)
                                
                            } else {
                                SecureField("Enter your password", text: $viewModel.password)
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
                        
                        
                        NavigationLink {
                            ForgotPasswordView()
                        } label: {
                            Text("Forgot Password?")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .padding(.top)
                                .padding(.trailing, 28)
                                .foregroundColor(Color.theme.primaryText)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        Button {
                            Task { try await viewModel.login() }
                        } label: {
                            
                            Text("Login")
                                .foregroundColor(Color.theme.primaryBackground)
                                .modifier(ThreadsButtonModifier())
                                .fontWeight(.semibold)
                                .padding(.vertical,15)
                                .frame(maxWidth: .infinity)
                            
                        }
                    
                        .padding(.vertical)
                        
                        Spacer()
                        //                Text("By continuing you accept our")
                        //                    .foregroundColor(.gray)
                        //                Button("Terms and Privacy Policy")
                        //                            Text("and acknowledge that you understand how we collect, use, and share your data.")
                        //                {
                        //                    Divider()
                        
                        NavigationLink {
                            RegistrationView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            HStack(spacing: 3) {
                                //                            Text("Don't have an account?")
                                
                                Text("Create a new account")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(Color.theme.primaryText)
                            .font(.footnote)
                        }
                        .padding(.vertical, 10)
                        
                        Image("Flow-app-icon")
                            .renderingMode(.template)
                            .resizable()
                            .colorMultiply(Color.theme.primaryText)
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(.vertical, 5)
                        
                    }
                }
            }
        }
        
        struct LoginView_Previews: PreviewProvider {
            static var previews: some View {
                LoginView()
            }
        }
    }

