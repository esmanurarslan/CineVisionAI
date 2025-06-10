import SwiftUI

struct ContentView: View {
    @StateObject private var authVM = AuthViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "#1B1525"), location: 0.0),
                        .init(color: Color(hex: "#1B1525"), location: 0.8),
                        .init(color: Color("myPurple"), location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 32) {
                    Spacer().frame(height: 30)

                    HStack {
                        Rectangle()
                            .fill(Color("myYellow"))
                            .frame(height: 4)
                            .frame(maxWidth: UIScreen.main.bounds.width / 2)
                            .shadow(color: Color("myYellow"), radius: 20)
                        Spacer()
                    }

                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sign In")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(Color("myPurple"))
                                .padding(.leading)

                            Text("Hi there! Nice to see you again.")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.leading)
                        }
                        .padding(.horizontal, 24)
                    }

                    HStack {
                        Spacer()
                        Rectangle()
                            .fill(Color("myYellow"))
                            .frame(height: 4)
                            .frame(maxWidth: UIScreen.main.bounds.width / 2)
                            .shadow(color: Color("myYellow"), radius: 8)
                    }

                    VStack(spacing: 8) {
                        Image("icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .shadow(color: Color("myYellow").opacity(0.75), radius: 10)

                        Text("CineVisionAI")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color("myYellow"))
                            .shadow(color: Color("myYellow").opacity(0.75), radius: 10)
                    }
                    .frame(maxWidth: .infinity)

                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .foregroundColor(Color("myYellow"))
                                .font(.title3)

                            TextField("Your Mail", text: $authVM.email)
                                .foregroundColor(.white)
                                .placeholder(when: authVM.email.isEmpty) {
                                    Text("Your Mail")
                                        .foregroundColor(.white)
                                }
                                .padding(.vertical, 6)

                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(Color("myPurple"))
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .foregroundColor(Color("myYellow"))
                                .font(.title3)

                            SecureField("Your password", text: $authVM.password)
                                .foregroundColor(.white)
                                .placeholder(when: authVM.password.isEmpty) {
                                    Text("Your password")
                                        .foregroundColor(.white)
                                }
                                .padding(.vertical, 6)

                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(Color("myPurple"))
                        }
                    }
                    .padding(.horizontal, 24)

                    HStack {
                        Button("Forgot Password?") {
                            authVM.resetPassword { _ in }
                        }
                        .foregroundColor(.white)
                        .font(.footnote)

                        Spacer()

                        NavigationLink(destination: SignUpView()) {
                            Text("Create Account")
                                .foregroundColor(Color("myYellow"))
                                .font(.footnote)
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer()

                    VStack(spacing: 20) {
                        Button(action: {
                            authVM.login { _ in }
                        }) {
                            Text("Sign In")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("myYellow"))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: Color("myYellow"), radius: 8)
                        }

                        NavigationLink(
                            destination: WelcomeView(),
                            isActive: $authVM.isAuthenticated
                        ) {
                            EmptyView()
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
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

#Preview {
    ContentView()
}
