//
//  WelcomeView.swift
//  CineVisionAI
//
//  Created by Esma Nur Arslan on 14.04.2025.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        // NavigationView { // <<< BU SATIR KALDIRILDI
        VStack(spacing: 20) {
            Image("Movıe")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundColor(.cyan)
                .padding(.bottom, 30)

            VStack(alignment: .leading, spacing: 10) {
                Text("Welcome to CineVisionAI!")
                    .foregroundColor(.cyan)
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                Text("What do you see when you look at a poster?\nColors, faces, maybe a clue...\nBut what if we told you it could reveal the genre of a film?\nJust give us a poster and a brief summary, and let us do the rest.\nLet’s discover which genre your next movie belongs to!")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 20) // Bu padding zaten vardı, dokunmadım

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
        .navigationTitle("Welcome") // <<< İsteğe bağlı: Navigasyon başlığı eklendi
        .navigationBarTitleDisplayMode(.inline) // Başlığın stilini ayarlar
        // .navigationBarHidden(true) // <<< Genellikle bir sonraki view'a geçişte bar görünür olur.
                                    // İsterseniz aktif edebilirsiniz ama geri butonu da gizlenir.
        // } // <<< BU SATIR KALDIRILDI
        // .navigationViewStyle(StackNavigationViewStyle()) // <<< BU SATIR KALDIRILDI
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview için hala bir NavigationView'a ihtiyacımız var
        NavigationView {
            WelcomeView()
        }
    }
}
