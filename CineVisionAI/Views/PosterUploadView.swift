import SwiftUI

struct PosterUploadView: View {
    @StateObject private var viewModel = CloudViewModel()
    @State private var showImagePicker = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // GÖRSEL YÜKLEME ALANI
                VStack(spacing: 10) {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .padding(.top, 60)
                            .onTapGesture { showImagePicker = true }
                    } else {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 100)
                            .foregroundColor(.gray)
                            .padding(.top, 60)
                            .onTapGesture { showImagePicker = true }
                        Text("Tap to Upload Poster")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .padding(.top, 5)
                    }
                }
                .padding(.bottom, 30)
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $viewModel.selectedImage)
                }

                // FİLM ÖZETİ GİRİŞİ
                VStack(alignment: .leading, spacing: 10) {
                    Text("If you want a better prediction result, please add the plot summary of the movie in the field below")
                        .foregroundColor(.cyan)
                        .font(.title3)
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)

                VStack(alignment: .leading, spacing: 15) {
                    TextEditor(text: $viewModel.summaryText)
                        .frame(height: 120)
                        .foregroundColor(Color(.darkGray))
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                        )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)

                NavigationLink(
                    destination: OutputView(image: viewModel.selectedImage, predictedGenres: viewModel.predictedGenresForOutput),
                    isActive: $viewModel.showOutputView
                ) { EmptyView() }

                Button(action: {
                    viewModel.uploadPoster()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.cyan)
                            .cornerRadius(8)
                    } else {
                        Text("Generate Caption & Log Result")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.selectedImage != nil ? Color.cyan : Color.cyan.opacity(0.5))
                            .cornerRadius(8)
                    }
                }
                .padding(.bottom)
                .disabled(viewModel.selectedImage == nil || viewModel.isLoading)

                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Upload Poster")
                    .foregroundColor(.primary)
            }
        }
        .navigationTitle("")
        .toast(message: viewModel.toastMessage ?? "", isShowing: $viewModel.isShowingToast, isSuccess: false)
    }
}




// Cloud Run API'sine istek gönderen fonksiyon (Değişiklik yok)
// Bu fonksiyon zaten hataları ve başarı durumunu konsola yazdırıyor.
// Completion bloğu sadece başarılı caption'ı (String?) döndürüyor.
func sendImageToCloudRunAPI(image: UIImage, completion: @escaping (String?) -> Void) {
    guard let url = URL(string: "https://florence-api-703816911315.europe-west1.run.app/caption") else {
        print("CONSOLE ERROR: Invalid Cloud Run API URL")
        DispatchQueue.main.async { completion(nil) }
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.timeoutInterval = 120

    let boundary = "Boundary-\(UUID().uuidString)"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    var body = Data()
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        print("CONSOLE ERROR: Image data conversion failed.")
        DispatchQueue.main.async { completion(nil) }
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

    print("CONSOLE INFO: Sending request to Cloud Run API...")
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("CONSOLE ERROR: Cloud Run API Request failed: \(error.localizedDescription)")
            DispatchQueue.main.async { completion(nil) }
            return
        }

        if let httpResponse = response as? HTTPURLResponse {
            print("CONSOLE INFO: Cloud Run API Status Code: \(httpResponse.statusCode)")
        }
        
        guard let data = data else {
            print("CONSOLE ERROR: No data received from Cloud Run API.")
            DispatchQueue.main.async { completion(nil) }
            return
        }
        
        if let rawResponse = String(data: data, encoding: .utf8) {
             print("CONSOLE INFO: Raw API response: \(rawResponse)") // Ham yanıtı her zaman yazdır
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let captionText = json["caption"] as? String {
                    // Başarılı caption'ı completion ile geri döndür
                    DispatchQueue.main.async { completion(captionText) }
                } else if let errorMsg = json["error"] as? String {
                    print("CONSOLE ERROR: Cloud Run API returned an error in JSON: \(errorMsg)")
                    DispatchQueue.main.async { completion(nil) } // Hata durumunda nil döndür
                } else {
                    print("CONSOLE ERROR: Unexpected JSON format from Cloud Run API (missing 'caption' or 'error').")
                    DispatchQueue.main.async { completion(nil) }
                }
            } else {
                print("CONSOLE ERROR: Could not parse JSON response from Cloud Run API.")
                DispatchQueue.main.async { completion(nil) }
            }
        } catch {
            print("CONSOLE ERROR: Cloud Run API JSON parsing error: \(error.localizedDescription).")
            DispatchQueue.main.async { completion(nil) }
        }
    }
    task.resume()
}

// SwiftUI Previews (Değişiklik yok)
struct PosterUploadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PosterUploadView()
        }
    }
}



