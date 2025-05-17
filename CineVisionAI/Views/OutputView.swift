//
//  OutputView.swift
//  CineVisionAI
//

import SwiftUI

struct OutputView: View {
    let image: UIImage?
    let predictedGenres: [String]
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var rootViewManager: RootViewManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // İÇERİK OLDUĞU GİBİ KALDI
                if let uiImage = image {
                    Image(uiImage: uiImage).resizable().scaledToFit().frame(maxWidth: 300, maxHeight: 350)
                        .cornerRadius(12).shadow(radius: 5).padding(.horizontal)
                    // .padding(.top, 50) // İsteğe bağlı
                } else {
                    Image(systemName: "photo.on.rectangle.angled").resizable().scaledToFit().frame(width: 150, height: 200)
                        .foregroundColor(.gray.opacity(0.7)).padding(.vertical, 100).padding(.horizontal)
                    Text("No image was provided.").foregroundColor(.gray).font(.headline).padding(.bottom, 30)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Predicted Movie Genres:").font(.title2).foregroundColor(.cyan).padding(.bottom, 5)
                    if predictedGenres.isEmpty {
                        Text("No genres predicted yet.").font(.headline).foregroundColor(.gray)
                    } else {
                        ForEach(predictedGenres, id: \.self) { genre in
                            HStack {
                                Image(systemName: "film.fill").foregroundColor(.cyan)
                                Text(genre).frame(width: 150, height: 20, alignment: .center).font(.callout)
                            }
                            .padding(.leading)
                        }
                    }
                }
                .padding(.top, 20).padding(.horizontal)
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        // .padding(.top, 40) // Bu padding'i yorumda bırakıyorum, genellikle gerekmez
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) { // Sağ tarafa çıkış butonu
                Button {
                    rootViewManager.resetToRoot() // ContentView'a (başlangıca) dön
                } label: {
                    Image(systemName: "power.circle.fill") // Çıkış için uygun bir ikon
                    // Text("Exit") // İsteğe bağlı metin
                }
                .foregroundColor(.cyan) // Genellikle çıkış için kullanılan bir renk
            }
        }
    }
    
    struct OutputView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView { // Preview için
                OutputView(
                    image: UIImage(systemName: "film"),
                    predictedGenres: ["Action", "Sci-Fi", "Adventure"]
                )
                .environmentObject(RootViewManager())
            }
        }
    }
}
