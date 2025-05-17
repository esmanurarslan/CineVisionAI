//
//  View+Extensions.swift
//  CineVisionAI
//
//  Created by Umut Kaya Ergüler on 17.05.2025.
//

import SwiftUI

extension View {
    func toast(message: String, isShowing: Binding<Bool>, isSuccess: Bool = false, frame: CGFloat = 60) -> some View {
        self.modifier(Toast(message: message, isShowing: isShowing, isSuccess: isSuccess, frame: frame))
    }
}
