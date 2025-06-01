//
//  CloudViewModel.swift
//  CineVisionAI
//
//  Created by Umut Kaya Ergüler on 17.05.2025.
//  

// CloudViewModel.swift
import SwiftUI
import Combine

class CloudViewModel: BaseViewModel {
    @Published var selectedImage: UIImage?
    @Published var summaryText: String = "" // Kullanıcının girdiği özet metni
    
    // Tür Tahmin API'sinden dönen sonuçlar
    @Published var predictedGenresForOutput: [String] = []
    @Published var genreProbabilitiesForOutput: [GenreProbabilityAPI] = [] // APIDataModels'dan

    @Published var showOutputView = false

    // DİKKAT: Bu URL'leri kendi canlı URL'lerinizle güncelleyin!
    private let captionServiceURL = "https://florence-api-703816911315.europe-west1.run.app/caption"
    private let genrePredictionServiceURL = "https://movie-genre-service-80397271793.europe-west2.run.app/predict/" // SİZİN TÜR TAHMİN API URL'NİZ

    // `uploadPoster` yerine bu fonksiyon kullanılacak
    func processForGenrePrediction() {
        guard let image = selectedImage else {
            showToast("Lütfen önce bir poster yükleyin.")
            return
        }
        guard !summaryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showToast("Lütfen film özetini girin.")
            return
        }

        isLoading = true
        predictedGenresForOutput = []
        genreProbabilitiesForOutput = []

        print("CONSOLE INFO (ViewModel): Adım 1 - Caption API'sine istek gönderiliyor...")
        CloudService.shared.fetchCaption(from: captionServiceURL, image: image) { [weak self] captionResult in
            guard let self = self else { return }

            switch captionResult {
            case .success(let captionResponse):
                if let caption = captionResponse.caption, !caption.isEmpty {
                    print("CONSOLE INFO (ViewModel): Caption başarıyla alındı: \(caption)")
                    // Adım 2: Tür Tahmini
                    self.fetchGenrePrediction(
                        image: image,
                        userSummary: self.summaryText,
                        generatedCaption: caption
                    )
                } else {
                    let errorMsg = captionResponse.error ?? "Caption API'sinden boş veya hatalı caption yanıtı."
                    print("CONSOLE ERROR (ViewModel): \(errorMsg)")
                    self.showToast(errorMsg)
                    DispatchQueue.main.async { self.isLoading = false }
                }
            case .failure(let error):
                print("CONSOLE ERROR (ViewModel): Caption API isteği başarısız - \(error.localizedDescription)")
                self.showToast("Poster açıklaması alınamadı: \(error.localizedDescription)")
                DispatchQueue.main.async { self.isLoading = false }
            }
        }
    }

    private func fetchGenrePrediction(image: UIImage, userSummary: String, generatedCaption: String) {
            print("CONSOLE INFO (ViewModel): Adım 2 - Tür Tahmin API'sine istek gönderiliyor...")
            
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                self.showToast("Görüntü verisi hazırlanamadı.")
                DispatchQueue.main.async { self.isLoading = false }
                return
            }
            let imageBase64String = imageData.base64EncodedString()

            let requestBodyPayload = CloudService.GenrePredictionRequestBody( // requestBodyPayload olarak değiştirdim, daha net
                image_base64: imageBase64String,
                text1: userSummary,
                text2: generatedCaption
            )
            
            // HATA BURADAYDI, ŞİMDİ DÜZELTİLDİ:
            // 'body:' yerine 'requestBody:' kullanılacak
            CloudService.shared.fetchGenrePrediction(from: genrePredictionServiceURL,
                                                      requestBody: requestBodyPayload) { [weak self] (genreResult: Result<GenrePredictionResponseAPI, Error>) in // Tip belirtmesi de ekledim
                DispatchQueue.main.async { // Her zaman UI güncellemelerini ana thread'de yap
                    guard let self = self else { return }
                    self.isLoading = false // Yükleme bitti

                    switch genreResult {
                    case .success(let predictionResponse):
                        if let apiError = predictionResponse.error {
                            print("CONSOLE ERROR (ViewModel): Tür Tahmin API'sinden hata: \(apiError)")
                            self.showToast("Tür tahmininde hata: \(apiError)")
                        } else {
                            print("CONSOLE INFO (ViewModel): Tür tahmini başarıyla alındı.")
                            self.predictedGenresForOutput = predictionResponse.predicted_genres_thresholded
                            self.genreProbabilitiesForOutput = predictionResponse.probabilities
                            self.showOutputView = true
                        }
                    case .failure(let error):
                        print("CONSOLE ERROR (ViewModel): Tür Tahmin API isteği başarısız - \(error.localizedDescription)")
                        self.showToast("Türler tahmin edilemedi: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
