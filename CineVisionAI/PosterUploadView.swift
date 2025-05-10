//
//  PosterUploadView.swift
//  CineVisionAI
//
//  Created by Esma Nur Arslan on 21.03.2025.
//

import SwiftUI
import PhotosUI

struct PosterUploadView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var summaryText: String = ""
    @State private var sentenceCount = 0
    @State private var showOutputView = false
    @State private var predictedGenresForOutput: [String] = []

    var body: some View {
        // NavigationView { // <<< BU SATIR KALDIRILDI
        ScrollView {
            VStack(spacing: 20) {
                // GÖRSEL YÜKLEME ALANI (İÇERİK AYNI)
                VStack(spacing: 10) {
                    if let image = selectedImage {
                        Image(uiImage: image).resizable().scaledToFit().frame(width: 150, height: 150)
                            .cornerRadius(8).shadow(radius: 3).padding(.top, 60)
                            .onTapGesture { showImagePicker = true }
                    } else {
                        Image(systemName: "photo.on.rectangle.angled").resizable().scaledToFit().frame(width: 120, height: 100)
                            .foregroundColor(.gray).padding(.top, 60)
                            .onTapGesture { showImagePicker = true }
                        Text("Tap to Upload Poster").foregroundColor(.gray).font(.subheadline).padding(.top, 5)
                    }
                }
                .padding(.bottom, 30)
                .sheet(isPresented: $showImagePicker) { ImagePicker(selectedImage: $selectedImage) }

                // FİLM ÖZETİ GİRİŞ ALANI (İÇERİK AYNI)
                VStack(alignment: .leading, spacing: 10) {
                    Text("If you want a better prediction result, please add the plot summary of the movie in the field below ")
                        .foregroundColor(.cyan).font(.title3).fontWeight(.medium)
                }
                .frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, 5)

                VStack(alignment: .leading, spacing: 15) {
                    TextEditor(text: $summaryText).frame(height: 120).foregroundColor(Color(.darkGray)).padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.7), lineWidth: 1))
                        .onChange(of: summaryText) { newValue, oldValue in /* ... mevcut kod ... */ }
                }
                .frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, 20)

                // OUTPUTVIEW'A GİTMEK İÇİN GİZLİ NAVIGATIONLINK (İÇERİK AYNI)
                NavigationLink(
                    destination: OutputView(image: selectedImage, predictedGenres: predictedGenresForOutput),
                    isActive: $showOutputView
                ) { EmptyView() }

                // PREDICT GENRE BUTONU (İÇERİK AYNI)
                Button(action: {
                    print("Predict button tapped")
                    if selectedImage != nil {
                        self.predictedGenresForOutput = ["Fantasy", "Adventure", "Comedy"]
                        self.showOutputView = true
                    } else {
                        print("Please select an image.") // Mesajı güncelledim
                    }
                }) {
                    Text("Predict Genre").fontWeight(.semibold).foregroundColor(.white).padding().frame(maxWidth: .infinity)
                        .background((selectedImage != nil) ? Color.cyan : Color.cyan.opacity(0.5))
                        .cornerRadius(8)
                }
                .padding(.bottom)
                .disabled(selectedImage == nil)
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { // Özel başlık için
            ToolbarItem(placement: .principal) {
                Text("Upload Movie Details")
                    .foregroundColor(.white) // Arka planınız beyazsa bu görünmez, .black veya .primary yapın
            }
        }
        .navigationTitle("") // .toolbar'daki özel başlıkla çakışmaması için
        // } // <<< BU SATIR KALDIRILDI
        // .navigationViewStyle(StackNavigationViewStyle()) // <<< BU SATIR KALDIRILDI
    }
}// ImagePicker ve PosterUploadView_Previews kodları aynı kalabilir
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1 // Sadece 1 resim
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
                    DispatchQueue.main.async { // UI güncellemeleri ana thread'de yapılmalı
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

struct PosterUploadView_Previews: PreviewProvider {
    static var previews: some View {
        PosterUploadView()
    }
}
