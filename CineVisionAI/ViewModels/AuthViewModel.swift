//
//  AuthViewModel.swift
//  CineVisionAI
//
//  Created by Umut Kaya Ergüler on 17.05.2025.
//

import Foundation
import FirebaseAuth


class AuthViewModel: BaseViewModel {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isAuthenticated = false

    func register(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty, password == confirmPassword else {
            showToast("Please fill in all fields and make sure passwords match.")
            completion(false)
            return
        }

        guard isValidEmail(email) else {
            showToast("Please enter a valid email address.")
            completion(false)
            return
        }

        guard isPasswordStrong(password) else {
            showToast("Password must contain at least 1 uppercase letter, 1 number, and 1 special character (! or .)")
            completion(false)
            return
        }

        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        Auth.auth().createUser(withEmail: normalizedEmail, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showToast(error.localizedDescription)
                    completion(false)
                } else if let user = result?.user {
                    FirestoreService.shared.createUserDocument(uid: user.uid, email: normalizedEmail) { firestoreError in
                        if let firestoreError = firestoreError {
                            self.showToast(self.translateFirestoreError(firestoreError))
                            completion(false)
                        } else {
                            completion(true)
                            self.showToast("Registration successful! Please sign in.")
                        }
                    }
                } else {
                    self.showToast("An unknown error occurred.")
                    completion(false)
                }
            }
        }
    }

    func login(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            showToast("Email or password cannot be empty.")
            completion(false)
            return
        }

        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        AuthService.shared.login(email: normalizedEmail, password: password) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showToast(error.localizedDescription)
                    completion(false)
                }
            } else {
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    completion(true)
                }
            }
        }
    }


    
    func resetPassword(completion: @escaping (Bool) -> Void) {

        guard !email.isEmpty else {
            showToast("Please enter your email first.")
            completion(false)
            return
        }

        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        AuthService.shared.resetPassword(email: normalizedEmail) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showToast(error.localizedDescription)
                    completion(false)
                } else {
                    self.showToast("Password reset email sent.")
                    completion(true)
                }
            }
        }
    }

    func logout() {

        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
            self.email = ""
            self.password = ""
            self.confirmPassword = ""
        } catch {
            self.showToast("Logout failed: \(error.localizedDescription)")
        }
    }



    private func isPasswordStrong(_ password: String) -> Bool {
        let uppercasePattern = ".*[A-Z]+.*"
        let digitPattern = ".*[0-9]+.*"
        let specialCharPattern = ".*[!.]+.*"

        let uppercaseCheck = NSPredicate(format: "SELF MATCHES %@", uppercasePattern)
        let digitCheck = NSPredicate(format: "SELF MATCHES %@", digitPattern)
        let specialCheck = NSPredicate(format: "SELF MATCHES %@", specialCharPattern)

        return password.count >= 6 &&
               uppercaseCheck.evaluate(with: password) &&
               digitCheck.evaluate(with: password) &&
               specialCheck.evaluate(with: password)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailCheck.evaluate(with: email)
    }
    
    func clearFields() {
        email = ""
        password = ""
        confirmPassword = ""
    }
}

extension AuthViewModel {
    func translateAuthError(_ error: Error) -> String {
        guard let errCode = AuthErrorCode(rawValue: (error as NSError).code) else {
            return error.localizedDescription
        }


        switch errCode {
        case .invalidEmail:
            return "The email address is badly formatted."
        case .emailAlreadyInUse:
            return "The email address is already in use."
        case .weakPassword:
            return "The password is too weak."
        case .wrongPassword:
            return "The password is invalid."
        case .userNotFound:
            return "No user found with this email."
        case .userDisabled:
            return "The user account has been disabled."
        case .tooManyRequests:
            return "Too many attempts. Try again later."
        case .operationNotAllowed:
            return "This operation is not allowed."
        case .networkError:
            return "Network error occurred."
        case .invalidCredential:
            return "Invalid or expired login credential."
        case .requiresRecentLogin:
            return "This action requires recent login."
        default:
            return error.localizedDescription
        }
    }
    
    func translateFirestoreError(_ error: Error) -> String {
        let nsError = error as NSError

        switch nsError.code {
        case 1:
            return "The operation was cancelled."
        case 2:
            return "An unknown error occurred."
        case 3:
            return "Invalid argument sent to the server."
        case 4:
            return "The operation timed out."
        case 5:
            return "Document not found."
        case 6:
            return "The document already exists."
        case 7:
            return "Permission denied."
        case 9:
            return "Operation rejected due to failed precondition."
        case 10:
            return "The operation was aborted due to a conflict."
        case 13:
            return "Internal server error in Firestore."
        case 14:
            return "Firestore service is currently unavailable."
        case 16:
            return "Authentication required."
        default:
            return error.localizedDescription
        }
    }

}

