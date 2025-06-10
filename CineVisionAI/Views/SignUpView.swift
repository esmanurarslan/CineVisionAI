import SwiftUI

struct SignUpView: View {
    @StateObject private var authVM = AuthViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // GRADIENT BACKGROUND
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

            VStack(spacing: 20) {
                TextField("Email", text: $authVM.email)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $authVM.password)
                    .textFieldStyle(.roundedBorder)

                SecureField("Confirm Password", text: $authVM.confirmPassword)
                    .textFieldStyle(.roundedBorder)

                Button("Sign Up") {
                    authVM.register { success in
                        if success {
                            dismiss()
                        }
                    }
                }
                .padding(.top)
            }
            .padding()
        }
        .toast(
            message: authVM.toastMessage ?? "",
            isShowing: $authVM.isShowingToast,
            isSuccess: false
        )
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
