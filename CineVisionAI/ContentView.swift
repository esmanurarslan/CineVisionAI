//
//  ContentView.swift
//  CineVisionAI
//
//  Created by Esma Nur Arslan on 21.03.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var email: String = "example@email.com"
    @State private var password: String = "password"
    @State private var isPasswordVisible: Bool = false
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Image( "Movıe")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                    
               
                }
                .padding(.bottom, 40)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sign In")
                        .foregroundColor(.cyan)
                        .font(.largeTitle)
                    
                    Text("Hi there! Nice to see you again.")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Email")
                        .foregroundColor(.gray)
                    
                    VStack {
                        TextField("", text: $email)
                            .foregroundColor(.white)
                            .padding(.vertical, 5) // Daha temiz görünüm için
                        
                        Rectangle() // Alt çizgi
                            .frame(height: 1)
                            .foregroundColor(.gray)
                    }
                    
                    Text("Password")
                        .foregroundColor(.gray)
                    
                    VStack {
                        ZStack(alignment: .trailing) {
                            if isPasswordVisible {
                                TextField("", text: $password)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 5)
                            } else {
                                SecureField("", text: $password)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 5)
                            }
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Rectangle() // Alt çizgi
                            .frame(height: 1)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)
                
                NavigationLink(destination: WelcomeView()) { // NavigationLink ile WelcomeView'a geçiş sağlıyoruz
                                    Text("Sign in")
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.cyan)
                                        .cornerRadius(5)
                                }

                Spacer()
                HStack {
                    Button(action: {
                        // Handle forgot password action
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                    }) {
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .foregroundColor(.cyan)
                                .font(.footnote)
                        }
                        
                    }
                }
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding()
            
        }.navigationBarBackButtonHidden(true)
    }
}
            

#Preview {
    ContentView()
}
