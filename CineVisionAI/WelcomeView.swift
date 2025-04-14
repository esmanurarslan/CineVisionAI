//
//  WelcomeView.swift
//  CineVisionAI
//
//  Created by Esma Nur Arslan on 14.04.2025.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("Movıe") // Replace "Movıe" with the actual name of your welcome image asset
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.cyan)
                    .padding(.bottom, 30)

                Text("Welcome to CineVisionAI!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                    .padding(.bottom, 10)

                Text("What do you see when you look at a poster?\nColors, faces, maybe a clue...\nBut what if we told you it could reveal the genre of a film?\nJust give us a poster and a brief summary, and let us do the rest.\nLet’s discover which genre your next movie belongs to!")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 40)

                NavigationLink(destination: PosterUploadView()) {
                    Text("Upload a Poster")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()

                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
             // Optional: Set a title for the navigation bar
             // You might want to hide the navigation bar on the welcome screen
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures proper navigation behavior on older iOS versions
        .navigationBarHidden(true)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
