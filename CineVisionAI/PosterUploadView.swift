//
//  PosterUploadView.swift
//  CineVisionAI
//
//  Created by Esma Nur Arslan on 21.03.2025.
//

import SwiftUI
import PhotosUI // For ImagePicker

struct PosterUploadView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var summaryText: String = ""
    @State private var sentenceCount = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Image(systemName: "photo.on.rectangle.angled") // Placeholder image
                        .resizable()
                        .frame(width: 120, height: 100)
                        .foregroundColor(.gray)
                        .padding(.top, 100)
                        .onTapGesture {
                            showImagePicker = true
                        }
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .cornerRadius(8)
                            .padding(.top, 10)
                            .onTapGesture {
                                showImagePicker = true
                            }
                    } else {
                        Text("Tap to Upload Poster")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
                .padding(.bottom, 40)
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Write the plot of the movie")
                        .foregroundColor(.cyan)
                        .font(.title3)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom,10
                )

                VStack(alignment: .leading, spacing: 15) {
                   

                    VStack {
                        TextEditor(text: $summaryText)
                            .frame(height: 100)
                            .foregroundColor(.black)
                            .padding(5)
                            .border(Color.gray)
                            .onChange(of: summaryText) { newValue in
                                sentenceCount = newValue.components(separatedBy: CharacterSet(charactersIn: ".?!")).filter { !$0.isEmpty }.count
                                if sentenceCount > 20 {
                                    let sentences = newValue.components(separatedBy: CharacterSet(charactersIn: ".?!")).filter { !$0.isEmpty }
                                    if sentences.count > 20 {
                                        summaryText = sentences.prefix(20).joined(separator: ".") + (newValue.hasSuffix(".") || newValue.hasSuffix("?") || newValue.hasSuffix("!") ? "" : ".")
                                        sentenceCount = 20
                                    }
                                }
                            }
                    }

        
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)

                Button(action: {
                    // İşlevler sonra eklenecek
                    print("Predict button tapped (functionality to be added later)")
                }) {
                    Text("Predict Genre")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background((selectedImage != nil && !summaryText.isEmpty && sentenceCount <= 10) ? Color.cyan : Color.gray.opacity(0.5))
                        .cornerRadius(5)
                }
                .padding(.bottom)
                .disabled(selectedImage == nil || summaryText.isEmpty || sentenceCount > 10)

                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

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
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.selectedImage = image as? UIImage
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
