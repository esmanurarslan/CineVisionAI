//
//  FireStoreService.swift
//  CineVisionAI
//
//  Created by Umut Kaya Ergüler on 17.05.2025.
//

import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()

    func createUserDocument(uid: String, email: String, completion: @escaping (Error?) -> Void) {
        let userData: [String: Any] = [
            "email": email,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(uid).setData(userData, merge: true, completion: completion)
    }
}
