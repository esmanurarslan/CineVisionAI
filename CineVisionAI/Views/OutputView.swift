import SwiftUI

struct OutputView: View {
    let image: UIImage?
    let predictedGenres: [String]
    let allProbabilities: [GenreProbabilityAPI]

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var rootViewManager: RootViewManager

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "#1B1525"), location: 0.0),
                    .init(color: Color(hex: "#1B1525"), location: 0.4),
                    .init(color: Color("myPurple"), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            
                VStack(spacing: 25) {
                    // Görsel Alanı
                    if let uiImage = image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .cornerRadius(12)
                            .shadow(radius: 6)
                            .padding(.horizontal)
                            .padding(.top, 20)
                    } else {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.vertical, 50)
                        Text("No image was provided.")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.headline)
                    }

                    // Tahmin Edilen Türler
                    // Predicted Movie Genres:
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Predicted Movie Genres:")
                            .font(.title2.bold())
                            .foregroundColor(Color("myYellow"))

                        if predictedGenres.isEmpty {
                            Text("No genres predicted.")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.6))
                        } else {
                            GenreWrapView(genres: predictedGenres)
                        }
                    }
                    .padding(.horizontal)

                    ScrollView {
                    // Olasılıklar
                    if !allProbabilities.isEmpty {
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 10)

                        Text("All Genre Probabilities:")
                            .font(.title2.bold())
                            .foregroundColor(Color("myYellow"))
                            .padding(.bottom, 5)

                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(allProbabilities.sorted { $0.probability > $1.probability }) { item in
                                if item.probability > 0.005 {
                                    HStack {
                                        Text(item.genre)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .frame(width: 140, alignment: .leading)

                                        ProgressView(value: item.probability, total: 1.0)
                                            .frame(height: 8)
                                            .tint(colorForProbability(item.probability))
                                            .background(Color.white.opacity(0.08))
                                            .cornerRadius(4)

                                        Text(String(format: "%.1f%%", item.probability * 100))
                                            .font(.caption.monospacedDigit())
                                            .foregroundColor(.white)
                                            .frame(width: 55, alignment: .trailing)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    Spacer(minLength: 50)
                }
                .padding(.vertical)
            }
        }
        //.navigationTitle("Prediction Results")
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Prediction Results")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    rootViewManager.resetToRoot()
                } label: {
                    Image(systemName: "house.fill")
                        .foregroundColor(Color("myYellow"))
                }
            }
        }
    }

    func colorForProbability(_ probability: Float) -> Color {
        if probability > 0.75 { return .green }
        else if probability > 0.50 { return .yellow }
        else if probability > 0.25 { return .orange }
        else { return .red.opacity(0.7) }
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

struct GenreWrapView: View {
    let genres: [String]
    let columns = [GridItem(.adaptive(minimum: 92), spacing: 10)]

        var body: some View {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                ForEach(genres, id: \.self) { genre in
                    Text(genre)
                        .font(.callout.weight(.medium))
                        .foregroundColor(.black.opacity(1)) // Sarı arka plana karşı siyah daha okunaklı olabilir
                    
                        // --- ÇÖZÜM BURADA ---
                        .frame(width: 100, height: 25) // 1. Her kapsüle sabit bir genişlik ve yükseklik veriyoruz.
                        // --- BİTTİ ---
                    
                        .background(Color("myYellow").opacity(0.9))
                        .clipShape(Capsule())
                        // Uzun metinlerin "..." ile kısaltılmasını önlemek için satır limitini kaldırabilir
                        // veya metnin küçülerek sığmasını sağlayabilirsiniz. Şimdilik böyle kalsın.
                }
            }
        }
}



// Eğer FlowLayout'u ayrı bir dosyada tanımlamadıysanız, buraya ekleyebilirsiniz:
struct FlowLayout<Content: View>: View {
    let items: [AnyHashable]
    let viewForItem: (AnyHashable) -> Content
    let spacing: CGFloat

    init<Data: Hashable>(
        items: [Data],
        spacing: CGFloat = 8,
        @ViewBuilder viewForItem: @escaping (Data) -> Content
    ) {
        self.items = items
        self.spacing = spacing
        self.viewForItem = { any in viewForItem(any as! Data) }
    }

    var body: some View {
        FlowLayoutContent(
            items: items,
            spacing: spacing,
            viewForItem: viewForItem
        )
    }

    private struct FlowLayoutContent: View {
        let items: [AnyHashable]
        let spacing: CGFloat
        let viewForItem: (AnyHashable) -> AnyView

        init(items: [AnyHashable], spacing: CGFloat, viewForItem: @escaping (AnyHashable) -> some View) {
            self.items = items
            self.spacing = spacing
            self.viewForItem = { AnyView(viewForItem($0)) }
        }

        @State private var totalHeight = CGFloat.zero

        var body: some View {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
            .frame(height: totalHeight)
        }

        private func generateContent(in geometry: GeometryProxy) -> some View {
            var width = CGFloat.zero
            var height = CGFloat.zero

            return ZStack(alignment: .topLeading) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    viewForItem(item)
                        .padding(.horizontal, spacing / 2)
                        .padding(.vertical, spacing / 2)
                        .alignmentGuide(.leading) { d in
                            if width + d.width > geometry.size.width {
                                width = 0
                                height += d.height + spacing
                            }
                            let result = width
                            width += d.width + spacing
                            return result
                        }
                        .alignmentGuide(.top) { _ in height }
                }
            }
            .background(viewHeightReader($totalHeight))
        }

        private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
            GeometryReader { geometry -> Color in
                DispatchQueue.main.async {
                    binding.wrappedValue = geometry.size.height
                }
                return .clear
            }
        }
    }
}
