//
//  APIDataModels.swift
//  CineVisionAI
//
//  Created by Esma Nur Arslan on 1.06.2025.
//
// APIDataModels.swift
import Foundation

// Florence Caption API'sinden dönecek yanıt için
struct CaptionResponseAPI: Decodable {
    let caption: String? // Eğer API sadece caption döndürüyorsa ve hata durumunda farklı bir yapı varsa, ona göre ayarlayın
    let error: String?   // Opsiyonel hata mesajı
    // VEYA Florence API'nizin tam yanıt yapısına göre güncelleyin.
    // Örneğin, sadece {"caption": "text"} dönüyorsa:
    // let caption: String
}

// Sizin Tür Tahmin FastAPI API'nizden dönecek yanıt için
struct GenreProbabilityAPI: Decodable, Identifiable {
    let genre: String
    let probability: Float
    var id: String { genre } // SwiftUI List/ForEach için
}

struct GenrePredictionResponseAPI: Decodable { // FastAPI'deki PredictionOutput Pydantic modeline karşılık gelir
    let probabilities: [GenreProbabilityAPI]
    let predicted_genres_thresholded: [String]
    let error: String? // FastAPI'den dönen hata mesajı için
}
