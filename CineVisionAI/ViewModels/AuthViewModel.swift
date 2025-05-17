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
            showToast("Tüm alanları doldurun ve şifreler eşleşsin.")
            completion(false)
            return
        }
        
        guard isValidEmail(email) else {
            showToast("Geçerli bir e-posta adresi girin.")
            completion(false)
            return
        }
        
        guard isPasswordStrong(password) else {
            showToast("Şifre en az 1 büyük harf, 1 rakam ve 1 özel karakter (! ya da .) içermelidir.")
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
                            self.isAuthenticated = true
                            completion(true)
                        }
                    }
                } else {
                    self.showToast("Bilinmeyen bir hata oluştu.")
                    completion(false)
                }
            }
        }
    }

    func login(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            showToast("E-posta veya şifre boş olamaz.")
            completion(false)
            return
        }
        
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        AuthService.shared.login(email: normalizedEmail, password: password) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showToast(error.localizedDescription)
                    completion(false)
                } else {
                    self.isAuthenticated = true
                    completion(true)
                }
            }
        }
    }

    func resetPassword(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty else {
            showToast("Lütfen önce e-posta girin.")
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
                    self.showToast("Şifre sıfırlama e-postası gönderildi.")
                    completion(true)
                }
            }
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
}

extension AuthViewModel {
    func translateAuthError(_ error: Error) -> String {
        guard let errCode = AuthErrorCode(rawValue: (error as NSError).code) else {
            return error.localizedDescription
        }

        let isTurkish = Locale.current.language.languageCode?.identifier == "tr"

        switch errCode {
        case .invalidEmail:
            return isTurkish ? "E-posta adresi geçersiz." : "The email address is badly formatted."
        case .emailAlreadyInUse:
            return isTurkish ? "Bu e-posta adresi zaten kullanımda." : "The email address is already in use."
        case .weakPassword:
            return isTurkish ? "Şifre çok zayıf." : "The password is too weak."
        case .wrongPassword:
            return isTurkish ? "Şifre yanlış." : "The password is invalid."
        case .userNotFound:
            return isTurkish ? "Bu e-posta adresine ait bir kullanıcı bulunamadı." : "No user found with this email."
        case .userDisabled:
            return isTurkish ? "Kullanıcı hesabı devre dışı bırakılmış." : "The user account has been disabled."
        case .tooManyRequests:
            return isTurkish ? "Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin." : "Too many attempts. Try again later."
        case .operationNotAllowed:
            return isTurkish ? "Bu işlem geçersiz." : "This operation is not allowed."
        case .networkError:
            return isTurkish ? "Ağ bağlantı hatası oluştu." : "Network error occurred."
        case .invalidCredential:
            return isTurkish ? "Giriş bilgisi geçersiz veya süresi dolmuş." : "Invalid or expired login credential."
        case .requiresRecentLogin:
            return isTurkish ? "Bu işlem için tekrar giriş yapmanız gerekiyor." : "This action requires recent login."
        default:
            return error.localizedDescription
        }
    }
    
    func translateFirestoreError(_ error: Error) -> String {
        let nsError = error as NSError
        let isTurkish = Locale.current.language.languageCode?.identifier == "tr"

        switch nsError.code {
        case 1:
            return isTurkish ? "İşlem iptal edildi." : "The operation was cancelled."
        case 2:
            return isTurkish ? "Bilinmeyen bir hata oluştu." : "An unknown error occurred."
        case 3:
            return isTurkish ? "Gönderilen veriler geçersiz." : "Invalid argument sent to the server."
        case 4:
            return isTurkish ? "İstek zaman aşımına uğradı." : "The operation timed out."
        case 5:
            return isTurkish ? "Belge bulunamadı." : "Document not found."
        case 6:
            return isTurkish ? "Bu belge zaten mevcut." : "The document already exists."
        case 7:
            return isTurkish ? "Yetkiniz yok." : "Permission denied."
        case 9:
            return isTurkish ? "İşlem ön koşulu sağlanmadı." : "Operation rejected due to failed precondition."
        case 10:
            return isTurkish ? "İşlem iptal edildi (çakışma)." : "The operation was aborted due to a conflict."
        case 13:
            return isTurkish ? "Firestore sunucusunda dahili bir hata oluştu." : "Internal server error in Firestore."
        case 14:
            return isTurkish ? "Firestore hizmeti şu anda kullanılamıyor." : "Firestore service is currently unavailable."
        case 16:
            return isTurkish ? "Lütfen giriş yapın." : "Authentication required."

        default:
            return error.localizedDescription
        }
    }

}

