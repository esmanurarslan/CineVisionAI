//
//  ContentView.swift
//  CineVisionAI
//
//  Created by Esma Nur Arslan on 21.03.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authVM = AuthViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("Movie")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 40)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sign In")
                        .foregroundColor(.cyan)
                        .font(.largeTitle)
                    
                    Text("Hi there! Nice to see you again.")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Email")
                        .foregroundColor(.gray)
                    TextField("", text: $authVM.email)
                        .foregroundColor(.black)
                        .padding(.vertical, 5)
                    Rectangle().frame(height: 1).foregroundColor(.gray)
                    
                    Text("Password")
                        .foregroundColor(.gray)
                    SecureField("", text: $authVM.password)
                        .foregroundColor(.black)
                        .padding(.vertical, 5)
                    Rectangle().frame(height: 1).foregroundColor(.gray)
                }
                
                NavigationLink(
                    destination: WelcomeView(),
                    isActive: $authVM.isAuthenticated
                ) {
                    EmptyView()
                }
                
                Button("Sign In") {
                    authVM.login { _ in }
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.cyan)
                .cornerRadius(5)
                
                Spacer()
                
                HStack {
                    Button("Forgot Password?") {
                        authVM.resetPassword { _ in }
                    }
                    .foregroundColor(.gray)
                    .font(.footnote)
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .foregroundColor(.cyan)
                            .font(.footnote)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        .toast(
            message: authVM.toastMessage ?? "",
            isShowing: $authVM.isShowingToast,
            isSuccess: false
        )
    }
}

#Preview {
    ContentView()
}
