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
        NavigationView { // <<< ANA NAVIGATIONVIEW BURADA BAŞLIYOR
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Image("Movıe") // Görsel adınızın doğru olduğundan emin olun
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray) // Image'a foregroundColor genellikle etki etmez, asset'in kendisi renklidir.
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
                            .foregroundColor(.black) // .white arka planı beyazsa görünmez, .black veya .primary yapın
                            .padding(.vertical, 5)
                        Rectangle().frame(height: 1).foregroundColor(.gray)
                    }

                    Text("Password")
                        .foregroundColor(.gray)
                    VStack {
                        ZStack(alignment: .trailing) {
                            if isPasswordVisible {
                                TextField("", text: $password)
                                    .foregroundColor(.black) // .white arka planı beyazsa görünmez
                                    .padding(.vertical, 5)
                            } else {
                                SecureField("", text: $password)
                                    .foregroundColor(.black) // .white arka planı beyazsa görünmez
                                    .padding(.vertical, 5)
                            }
                            Button(action: { isPasswordVisible.toggle() }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        Rectangle().frame(height: 1).foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)

                NavigationLink(destination: WelcomeView()) { // <<< WelcomeView'a geçiş
                    Text("Sign in")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .cornerRadius(5)
                }

                Spacer()
                HStack {
                    Button(action: { /* Handle forgot password */ }) {
                        Text("Forgot Password?")
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                    Spacer()
                    NavigationLink(destination: SignUpView()) { // SignUpView'ınızın da tanımlı olduğunu varsayıyorum
                        Text("Sign Up")
                            .foregroundColor(.cyan)
                            .font(.footnote)
                    }
                }
            }
            .padding()
            .background(Color.white) // VStack'in arka planı
            .cornerRadius(10)
            .padding() // En dış padding
            // ContentView'da navigasyon başlığına genellikle ihtiyaç olmaz,
            // ama gerekirse buraya .navigationTitle eklenebilir.
            // .navigationBarBackButtonHidden(true) // Bu genellikle root view'da gerekmez
        }
        .navigationViewStyle(StackNavigationViewStyle()) // En dış NavigationView'a uygulanır
    }
}

#Preview {
    ContentView()
}
