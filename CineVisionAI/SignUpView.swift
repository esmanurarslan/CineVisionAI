//
//  SignUpView.swift
//  CineVisionAI
//
//  Created by Esma Nur Arslan on 21.03.2025.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Image(systemName: "cloud.fill")
                    .resizable()
                    .frame(width: 60, height: 50)
                    .foregroundColor(.gray)
                
                Text("Company Name")
                    .foregroundColor(.gray)
                    .font(.title3)
            }
            .padding(.bottom, 40)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Sign Up")
                    .foregroundColor(.cyan)
                    .font(.largeTitle)
                
                Text("Create an account to get started.")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Email")
                    .foregroundColor(.gray)
                
                VStack {
                    TextField("", text: $email)
                        .foregroundColor(.black)
                        .padding(.vertical, 5)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                }
                
                Text("Password")
                    .foregroundColor(.gray)
                
                VStack {
                    ZStack(alignment: .trailing) {
                        if isPasswordVisible {
                            TextField("", text: $password)
                                .foregroundColor(.black)
                                .padding(.vertical, 5)
                        } else {
                            SecureField("", text: $password)
                                .foregroundColor(.black)
                                .padding(.vertical, 5)
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                }
                
                Text("Confirm Password")
                    .foregroundColor(.gray)
                
                VStack {
                    ZStack(alignment: .trailing) {
                        if isConfirmPasswordVisible {
                            TextField("", text: $confirmPassword)
                                .foregroundColor(.black)
                                .padding(.vertical, 5)
                        } else {
                            SecureField("", text: $confirmPassword)
                                .foregroundColor(.black)
                                .padding(.vertical, 5)
                        }
                        
                        Button(action: {
                            isConfirmPasswordVisible.toggle()
                        }) {
                            Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 20)
            
            Button(action: {
                // Handle sign up action
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.cyan)
                    .cornerRadius(5)
            }
            
            Spacer()
            
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                    .font(.footnote)
                
                NavigationLink(destination: ContentView()) {
                    Text("Sign In")
                        .foregroundColor(.cyan)
                        .font(.footnote)
                }
            }
            .padding(.top, 20) // Düzenli bir padding ekledik
        }
        .padding(.horizontal) // Sadece yatay padding
        .background(Color.white)
        .cornerRadius(10)
        .padding()
        .navigationBarBackButtonHidden(true)
       
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
