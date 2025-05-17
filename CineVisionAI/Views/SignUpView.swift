//
//  SignUpView.swift
//  CineVisionAI
//
//  Created by Esma Nur Arslan on 21.03.2025.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var authVM = AuthViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // Email, Password, Confirm alanları (kısaltıldı)
            TextField("Email", text: $authVM.email)
            SecureField("Password", text: $authVM.password)
            SecureField("Confirm Password", text: $authVM.confirmPassword)
            
            Button("Sign Up") {
                authVM.register { success in
                    if success {
                        dismiss()
                    }
                }
            }
        }
        .padding()
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
