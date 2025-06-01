//
//  BaseViewModel.swift
//  CineVisionAI
//
//  Created by Umut Kaya Ergüler on 17.05.2025.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    @Published var toastMessage: String? = nil
    @Published var isShowingToast = false
    @Published var isLoading: Bool = false
    
    func showToast(_ message: String) {
            self.toastMessage = message
            self.isShowingToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    // Sadece mevcut toast mesajı hala gösteriliyorsa gizle
                    if self.toastMessage == message {
                        self.isShowingToast = false
                    }
                }
        }
}
