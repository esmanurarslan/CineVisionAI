// OutputView.swift
// CineVisionAI
//

import SwiftUI

struct OutputView: View {
    let image: UIImage?
    let predictedGenres: [String]
    let allProbabilities: [GenreProbabilityAPI] // Bu parametre zaten doğru tanımlanmış
    
    @Environment(\.dismiss) var dismiss // Geri butonu için (eğer navigationBarBackButtonHidden(true) ise)
    @EnvironmentObject var rootViewManager: RootViewManager // Kök görünüme dönmek için

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // GÖRÜNTÜ ALANI
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300) // Max yükseklik ayarı
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .padding(.top, 20) // Biraz üst boşluk
                } else {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150) // Biraz daha belirgin
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.vertical, 50)
                    Text("No image was provided.")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                
                // TAHMİN EDİLEN TÜRLER
                VStack(alignment: .leading, spacing: 10) {
                    Text("Predicted Movie Genres:")
                        .font(.title2.bold()) // Biraz daha vurgulu
                        .foregroundColor(Color.cyan) // Renk tema ile uyumlu
                        .padding(.bottom, 5)

                    if predictedGenres.isEmpty {
                        Text("No genres predicted.") // Daha kısa mesaj
                            .font(.headline)
                            .foregroundColor(.gray)
                    } else {
                        // Türleri yan yana göstermek için FlowLayout (eğer tanımlıysa)
                        // Eğer FlowLayout yoksa, ForEach'i direkt VStack içinde kullanın
                        FlowLayout(alignment: .leading, spacing: 8) { // FlowLayout tanımınızın olması gerekir
                             ForEach(predictedGenres, id: \.self) { genre in
                                 Text(genre)
                                     .font(.callout.weight(.medium))
                                     .padding(.horizontal, 12)
                                     .padding(.vertical, 6)
                                     .background(Color.cyan.opacity(0.15))
                                     .clipShape(Capsule()) // Daha hoş görünüm
                             }
                         }
                    }
                }
                .padding(.horizontal)

                // TÜM OLASILIKLAR (Eğer varsa ve gösterilmek isteniyorsa)
                if !allProbabilities.isEmpty {
                    Divider().padding(.vertical, 15)
                    Text("All Genre Probabilities:")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(Color.cyan.opacity(0.8))
                        .padding(.bottom, 5)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        // Olasılıkları yüksekten düşüğe sırala
                        ForEach(allProbabilities.sorted { $0.probability > $1.probability }) { item in
                            // Sadece belirli bir eşiğin üzerindekileri göster (opsiyonel)
                            if item.probability > 0.005 { // %0.5'ten yüksekleri gösterelim
                                HStack {
                                    Text(item.genre)
                                        .font(.subheadline)
                                        .frame(width: 140, alignment: .leading) // Sabit genişlik
                                    
                                    ProgressView(value: item.probability, total: 1.0)
                                        .frame(height: 8)
                                        .accentColor(colorForProbability(item.probability))
                                        .cornerRadius(4)
                                    
                                    Text(String(format: "%.1f%%", item.probability * 100))
                                        .font(.caption.monospacedDigit()) // Rakamların aynı genişlikte olması için
                                        .frame(width: 55, alignment: .trailing)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                Spacer() // İçeriği yukarı iter
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical) // Genel dikey padding
        }
        .navigationTitle("Prediction Results") // Başlık
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false) // Geri butonu görünsün
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    rootViewManager.resetToRoot()
                } label: {
                    Image(systemName: "house.fill") // Daha uygun bir "ana sayfa" ikonu
                }
                .foregroundColor(.cyan)
            }
        }
    }
    
    // Olasılığa göre renk döndüren yardımcı fonksiyon
    func colorForProbability(_ probability: Float) -> Color {
        if probability > 0.75 { return .green }
        else if probability > 0.50 { return .yellow }
        else if probability > 0.25 { return .orange }
        else { return .red.opacity(0.8) }
    }
}

struct OutputView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OutputView(
                image: UIImage(systemName: "film.stack"), // Daha iyi bir placeholder
                predictedGenres: ["Action", "Sci-Fi", "Adventure", "Thriller", "Comedy"],
                // Preview için örnek allProbabilities verisi EKLEYİN:
                allProbabilities: [
                    GenreProbabilityAPI(genre: "Action", probability: 0.85),
                    GenreProbabilityAPI(genre: "Sci-Fi", probability: 0.70),
                    GenreProbabilityAPI(genre: "Adventure", probability: 0.65),
                    GenreProbabilityAPI(genre: "Thriller", probability: 0.40),
                    GenreProbabilityAPI(genre: "Comedy", probability: 0.30),
                    GenreProbabilityAPI(genre: "Drama", probability: 0.15)
                ]
            )
            .environmentObject(RootViewManager()) // RootViewManager'ı preview için ekleyin
            .environmentObject(CloudViewModel()) // Eğer OutputView CloudViewModel'dan bir şey kullanıyorsa
        }
    }
}

// Eğer APIDataModels.swift dosyanız yoksa veya bu dosya OutputView.swift tarafından
// görülemiyorsa, GenreProbabilityAPI struct'ını buraya (veya projenizin
// erişilebilir bir yerine) eklemeniz gerekir.
// İdeal olanı APIDataModels.swift dosyasının projenizin target'ına dahil olmasıdır.
/*
struct GenreProbabilityAPI: Decodable, Identifiable { // APIDataModels.swift'ten
    let genre: String
    let probability: Float
    var id: String { genre }
}
*/

// Eğer FlowLayout'u ayrı bir dosyada tanımlamadıysanız, buraya ekleyebilirsiniz:
struct FlowLayout<Content: View>: View {
    let content: () -> Content
    let alignment: HorizontalAlignment
    let spacing: CGFloat

    init(alignment: HorizontalAlignment = .leading, spacing: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.alignment = alignment
        self.spacing = spacing
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: Alignment(horizontal: alignment, vertical: .top)) {
            self.content()
                .padding(EdgeInsets(top: spacing / 2, leading: spacing / 2, bottom: spacing / 2, trailing: spacing / 2))
                .alignmentGuide(alignment, computeValue: { d in
                    if (abs(width - d.width) > g.size.width) {
                        width = 0
                        height -= d.height + spacing
                    }
                    let result = width
                    if d.width > 0 {
                        width -= d.width + spacing
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: { d in
                    let result = height
                    if d.height > 0 && width == 0 { /* New row, do nothing special with height */ }
                    return result
                })
        }
    }
}
