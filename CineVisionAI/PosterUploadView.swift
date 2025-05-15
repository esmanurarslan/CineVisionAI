import SwiftUI
import PhotosUI

struct PosterUploadView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    // Kaldırılan State'ler:
    // @State private var posterCaption: String = ""
    // @State private var isLoading: Bool = false
    
    // Bu state'ler ve TextEditor, caption üretimiyle doğrudan ilgili değil.
    // Eğer uygulamanızın başka bir yerinde kullanmıyorsanız bunları da kaldırabilirsiniz.
    // Şimdilik mevcut yapıdaki gibi bırakıyorum.
    @State private var summaryText: String = ""
    @State private var showOutputView = false
    @State private var predictedGenresForOutput: [String] = []


    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // GÖRSEL YÜKLEME ALANI (Değişiklik yok)
                VStack(spacing: 10) {
                    if let image = selectedImage {
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
                    ImagePicker(selectedImage: $selectedImage)
                }

                // FİLM ÖZETİ GİRİŞ ALANI (Değişiklik yok, isteğe bağlı)
                VStack(alignment: .leading, spacing: 10) {
                    Text("If you want a better prediction result, please add the plot summary of the movie in the field below ")
                        .foregroundColor(.cyan)
                        .font(.title3)
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)

                VStack(alignment: .leading, spacing: 15) {
                    TextEditor(text: $summaryText)
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
                
                // GÖRSELİN AÇIKLAMASI GÖSTERİMİ KALDIRILDI

                // OUTPUTVIEW'A GİTMEK İÇİN GİZLİ NAVIGATIONLINK (Değişiklik yok, isteğe bağlı)
                NavigationLink(
                    destination: OutputView(image: selectedImage, predictedGenres: predictedGenresForOutput),
                    isActive: $showOutputView
                ) { EmptyView() }

                // "Generate Caption" BUTONU
                Button(action: {
                    print("--- Generate Caption Button Tapped ---")
                    guard let image = selectedImage else {
                        print("ERROR: Please select an image first.")
                        return
                    }
                    
                    print("INFO: Starting API call to generate caption...")
                    sendImageToCloudRunAPI(image: image) { captionOrError in
                        if let response = captionOrError {
                            // Bu blok, API'den geçerli bir string (caption veya hata mesajı) döndüğünde çalışır.
                            // sendImageToCloudRunAPI içindeki JSON parse mantığına göre,
                            // başarılı olursa caption, hata olursa API'nin hata mesajı gelir.
                            // Eğer API'den {"caption": "..."} gelirse, captionOrError = "..." olur.
                            // Eğer API'den {"error": "..."} gelirse, captionOrError = nil olur (fonksiyonun mevcut mantığına göre),
                            // ve aşağıdaki "else" bloğu çalışır.
                            // Bu kısmı sendImageToCloudRunAPI'nin completion bloğuna göre ayarlamamız gerekebilir.
                            // Mevcut sendImageToCloudRunAPI, başarılı caption için String?, hata için nil döner.
                            // Bu yüzden aşağıdaki gibi olmalı:
                            if let caption = captionOrError { // captionOrError aslında sadece başarılı caption'ı içerir.
                                print("SUCCESS: Generated Caption from API: \"\(caption)\"")
                            }
                            // Not: sendImageToCloudRunAPI'nin completion'ı sadece String? (başarılı caption) döndürüyor.
                            // Hata durumları sendImageToCloudRunAPI içinde zaten konsola yazdırılıyor.
                            // Eğer hem başarıyı hem de hatayı tek bir String olarak almak isterseniz
                            // sendImageToCloudRunAPI'nin completion'ını (String?, String?) veya Result<String, Error> gibi
                            // bir yapıya dönüştürmek gerekebilir.
                            // Şimdilik, sendImageToCloudRunAPI'nin hataları kendi içinde logladığını varsayıyoruz.
                        } else {
                            // Bu blok, sendImageToCloudRunAPI'nin completion'ına nil geldiğinde çalışır.
                            // Bu genellikle API'den hata alındığı veya ağ sorunu olduğu anlamına gelir.
                            // Hata detayları sendImageToCloudRunAPI içinde zaten konsola yazdırılmış olmalı.
                            print("INFO: API call finished. Caption could not be generated or an error occurred. Check previous logs for details.")
                        }
                        print("--- API Call Finished ---")
                    }
                }) {
                    Text("Generate Caption & Log Result") // Buton metnini güncelledim
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedImage != nil ? Color.cyan : Color.cyan.opacity(0.5))
                        .cornerRadius(8)
                }
                .padding(.bottom)
                .disabled(selectedImage == nil) // Sadece resim yoksa butonu pasif yap
                
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
    }
}

// ImagePicker struct'ı (Değişiklik yok)
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Error loading image: \(error.localizedDescription)")
                            self.parent.selectedImage = nil
                            return
                        }
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
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

// Data extension'ı (Değişiklik yok)
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

// SwiftUI Previews (Değişiklik yok)
struct PosterUploadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PosterUploadView()
        }
    }
}
