// CloudService.swift
import UIKit // UIImage için
import Foundation

class CloudService {
    static let shared = CloudService()
    private init() {}

    // --- Florence Caption API'sine İstek Gönderen Fonksiyon ---
    func fetchCaption(from urlString: String, image: UIImage, completion: @escaping (Result<CaptionResponseAPI, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "CloudService.fetchCaption", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Geçersiz Caption API URL'i: \(urlString)"])
            print("CONSOLE ERROR: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 120 // Caption API için zaman aşımı

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            let error = NSError(domain: "CloudService.fetchCaption", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Görüntü verisi dönüştürülemedi (jpegData)"])
            print("CONSOLE ERROR: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }

        // Multipart form data oluşturma
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        print("CONSOLE INFO (CloudService): Sending request to Caption API at \(urlString)...")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("CONSOLE ERROR (CloudService - Caption): Ağ isteği başarısız - \(error.localizedDescription)")
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("CONSOLE INFO (CloudService - Caption): Status Code \(httpResponse.statusCode)")
            }

            guard let data = data else {
                let noDataError = NSError(domain: "CloudService.fetchCaption", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Caption API'sinden veri alınamadı (data is nil)."])
                print("CONSOLE ERROR: \(noDataError.localizedDescription)")
                DispatchQueue.main.async { completion(.failure(noDataError)) }
                return
            }
            
            // Ham yanıtı logla (debug için)
            if let rawResponse = String(data: data, encoding: .utf8) {
                 print("CONSOLE INFO (CloudService - Caption): Raw API response: \(rawResponse)")
            }

            // Yanıtı CaptionResponseAPI struct'ına decode et
            do {
                let decodedResponse = try JSONDecoder().decode(CaptionResponseAPI.self, from: data)
                DispatchQueue.main.async { completion(.success(decodedResponse)) }
            } catch let decodingError {
                print("CONSOLE ERROR (CloudService - Caption): JSON Decode Hatası - \(decodingError.localizedDescription)")
                // Decode hatası durumunda bile ham yanıtı loglamak faydalı olabilir (yukarıda yapıldı)
                DispatchQueue.main.async { completion(.failure(decodingError)) }
            }
        }.resume()
    }

    // --- Tür Tahmin API'sine (FastAPI) İstek Gönderen Fonksiyon ---
    // FastAPI'nizin beklediği body için bir struct (bu APIDataModels.swift'e de taşınabilir)
    struct GenrePredictionRequestBody: Encodable {
        let image_base64: String
        let text1: String
        let text2: String
    }

    func fetchGenrePrediction(from urlString: String, requestBody: GenrePredictionRequestBody, completion: @escaping (Result<GenrePredictionResponseAPI, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "CloudService.fetchGenrePrediction", code: 2001, userInfo: [NSLocalizedDescriptionKey: "Geçersiz Tür Tahmin API URL'i: \(urlString)"])
            print("CONSOLE ERROR: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 60 // Tür tahmini için zaman aşımı (API'nizin hızına göre ayarlayın)

        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch let encodingError {
            print("CONSOLE ERROR (CloudService - Genre): İstek body'si encode edilemedi - \(encodingError.localizedDescription)")
            DispatchQueue.main.async { completion(.failure(encodingError)) }
            return
        }
        
        print("CONSOLE INFO (CloudService): Sending request to Genre Prediction API at \(urlString)...")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("CONSOLE ERROR (CloudService - Genre): Ağ isteği başarısız - \(error.localizedDescription)")
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("CONSOLE INFO (CloudService - Genre): Status Code \(httpResponse.statusCode)")
            }

            guard let data = data else {
                let noDataError = NSError(domain: "CloudService.fetchGenrePrediction", code: 2002, userInfo: [NSLocalizedDescriptionKey: "Tür Tahmin API'sinden veri alınamadı (data is nil)."])
                print("CONSOLE ERROR: \(noDataError.localizedDescription)")
                DispatchQueue.main.async { completion(.failure(noDataError)) }
                return
            }

            // Ham yanıtı logla (debug için)
            if let rawResponse = String(data: data, encoding: .utf8) {
                 print("CONSOLE INFO (CloudService - Genre): Raw API response: \(rawResponse)")
            }
            
            // Yanıtı GenrePredictionResponseAPI struct'ına decode et
            do {
                let decodedResponse = try JSONDecoder().decode(GenrePredictionResponseAPI.self, from: data)
                DispatchQueue.main.async { completion(.success(decodedResponse)) }
            } catch let decodingError {
                print("CONSOLE ERROR (CloudService - Genre): JSON Decode Hatası - \(decodingError.localizedDescription)")
                DispatchQueue.main.async { completion(.failure(decodingError)) }
            }
        }.resume()
    }
}
