//
//  Toast.swift
//  CineVisionAI
//
//  Created by Umut Kaya Ergüler on 17.05.2025.
//


import SwiftUI

struct Toast: ViewModifier {
    
    private let config = Config()
    let message: String
    @Binding var isShowing: Bool
    let isSuccess: Bool
    var frame: CGFloat
    var icon: Image {
        isSuccess ? Image(systemName: "checkmark.circle") : Image(systemName: "exclamationmark.triangle")
    }

    private var backgroundColor: Color {
        isSuccess ?  Color(hex: "#00DE71") : Color(hex: "#E54B38")
    }
    
    
    func body(content: Content) -> some View {
        ZStack {
            content
            toastView
        }
    }
    
    private var toastView: some View {
        VStack {
            if isShowing {
                HStack(spacing: 18) {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                    Text(message)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(config.textColor)
                }
                .padding(.horizontal)
                .frame(height: frame)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(backgroundColor)
                .cornerRadius(16)
                .onTapGesture {
                    isShowing = false
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
                        isShowing = false
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 100)
        .animation(config.animation, value: isShowing)
        .transition(config.transition)
        .ignoresSafeArea()
        .zIndex(1)
    }
    
    struct Config {
        let textColor: Color = .white
        let duration: TimeInterval = 2
        let transition: AnyTransition = .slide
        let animation: Animation = .linear
    }
}
