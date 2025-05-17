//
//  CloudService.swift
//  CineVisionAI
//
//  Created by Umut Kaya Ergüler on 17.05.2025.
//

import UIKit

final class CloudService {
    static let shared = CloudService()
    private init() {}

    func uploadPoster(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
            // Buradaki kod sendImageToCloudRunAPI ile aynı mantık
            guard let url = URL(string: "https://florence-api-703816911315.europe-west1.run.app/caption") else {
                completion(.failure(NSError(domain: "URL", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid API URL"])))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.timeoutInterval = 120

            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var body = Data()
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                completion(.failure(NSError(domain: "IMAGE", code: 2, userInfo: [NSLocalizedDescriptionKey: "Image data conversion failed."])))
                return
            }

            let filename = "image.jpg"
            let mimetype = "image/jpeg"

            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
            body.append("--\(boundary)--\r\n")
            request.httpBody = body

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "DATA", code: 3, userInfo: [NSLocalizedDescriptionKey: "No data received from API."])))
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let caption = json["caption"] as? String {
                        completion(.success(caption))
                    } else if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                              let apiError = json["error"] as? String {
                        completion(.failure(NSError(domain: "API", code: 4, userInfo: [NSLocalizedDescriptionKey: apiError])))
                    } else {
                        completion(.failure(NSError(domain: "API", code: 5, userInfo: [NSLocalizedDescriptionKey: "Unexpected API response."])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
}
