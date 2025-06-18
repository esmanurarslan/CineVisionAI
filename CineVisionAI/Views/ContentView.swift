    import SwiftUI

    struct ContentView: View {
        @StateObject private var authVM = AuthViewModel()
        @State private var isSignIn = true          // ⬅️ hangi modda olduğumuzu tutar

        var body: some View {
            NavigationView {
                ZStack {
                    // GRADIENT BACKGROUND
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(hex: "#1B1525"), location: 0.0),
                            .init(color: Color(hex: "#1B1525"), location: 0.8),
                            .init(color: Color("myPurple"),   location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    VStack(spacing: 28) {

                        // ─────────── SEKME BAŞLIĞI + KAYAN ÇUBUK ───────────
                        VStack(spacing: 4) {
                            HStack {
                                Text("Sign In")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(isSignIn ? Color("myPurple") : .white)
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture {
                                        withAnimation {
                                            isSignIn = true
                                            authVM.clearFields()

                                        }
                                    }
                                Text("Sign Up")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(!isSignIn ? Color("myPurple") : .white)
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture {
                                        withAnimation {
                                            isSignIn = false
                                            authVM.clearFields()

                                        }
                                    }
                            }
                            
                            .padding(.top, 40)

                            GeometryReader { geo in
                                Rectangle()
                                    .fill(Color("myYellow"))
                                    .frame(width: geo.size.width / 2, height: 4)
                                    .offset(x: isSignIn ? 0 : geo.size.width / 2)
                                    .animation(.easeInOut(duration: 0.35), value: isSignIn)
                            }
                            .frame(height: 4)
                        }
                        .padding(.top, 40)
                        Spacer()
                        // ─────────── İCON + APP NAME ───────────
                        VStack(spacing: 8) {
                            Image("icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .shadow(color: Color("myYellow").opacity(0.75), radius: 10)

                            Text("CineVisionAI")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color("myYellow"))
                                .shadow(color: Color("myYellow").opacity(0.75), radius: 10)
                        }

                        // ─────────── FORM ALANI ───────────
                        VStack(spacing: 20) {
                            AuthField(title: "Email",
                                      text: $authVM.email,
                                      placeholder: "Your Mail")

                            AuthSecureField(title: "Password",
                                            text: $authVM.password,
                                            placeholder: "Your Password")

                            // Yalnızca Sign Up modunda “Confirm Password” göster
                            if !isSignIn {
                                AuthSecureField(title: "Confirm Password",
                                                text: $authVM.confirmPassword,
                                                placeholder: "Repeat Password")
                            }
                        }
                        .padding(.horizontal, 24)

                        // ─────────── UNUTTUM + MOD DEĞİŞTİR ───────────
                        HStack {
                            if isSignIn {
                                Button("Forgot Password?") {
                                    authVM.resetPassword { _ in }
                                }
                                .foregroundColor(.white)
                                .font(.footnote)
                            }
                            Spacer()
                            Button(isSignIn ? "Create Account" : "Already have an account?") {
                                withAnimation {
                                    isSignIn.toggle()
                                    authVM.clearFields()
                                }
                            }
                            .foregroundColor(Color("myYellow"))
                            .font(.footnote)
                        }
                        .padding(.horizontal, 24)

                        Spacer()

                        // ─────────── ANA BUTON ───────────
                        Button(action: {
                            if isSignIn {
                                authVM.login { _ in }
                            } else {
                                authVM.register { success in
                                    if success {
                                        authVM.password = ""
                                        authVM.confirmPassword = ""


                                        withAnimation {
                                            isSignIn = true
                                        }
                                    }
                                }

                            }
                        }) {
                            Text(isSignIn ? "Sign In" : "Sign Up")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("myYellow"))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: Color("myYellow"), radius: 8)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    } // VStack
                    NavigationLink(
                        destination: WelcomeView(),
                        isActive: $authVM.isAuthenticated
                    ) {
                        EmptyView()
                    }
                }     // ZStack
            }         // NavigationView
            .accentColor(.white)
            .navigationViewStyle(StackNavigationViewStyle())
            .toast(
                message: authVM.toastMessage ?? "",
                isShowing: $authVM.isShowingToast,
                isSuccess: false
            )
        }
        
    }

    // MARK: - YARDIMCI FIELD BİLEŞENLERİ
    private struct AuthField: View {
        let title: String
        @Binding var text: String
        let placeholder: String

        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .foregroundColor(Color("myYellow"))
                    .font(.title3)

                TextField("", text: $text)
                    .foregroundColor(.white)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder).foregroundColor(.white)
                    }
                    .padding(.vertical, 6)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)

                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Color("myPurple"))
            }
        }
    }

    private struct AuthSecureField: View {
        let title: String
        @Binding var text: String
        let placeholder: String

        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .foregroundColor(Color("myYellow"))
                    .font(.title3)

                SecureField("", text: $text)
                    .foregroundColor(.white)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder).foregroundColor(.white)
                    }
                    .padding(.vertical, 6)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Color("myPurple"))
            }
        }
    }
    // MARK: - Preview
    #Preview {
        ContentView()
    }
