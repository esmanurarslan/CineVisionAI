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
                            .resizable().scaledToFit().frame(width: 150, height: 150)
                            .cornerRadius(8).shadow(radius: 3)
                            .padding(.top, 60)
                            .onTapGesture { showImagePicker = true }
                    } else {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable().scaledToFit().frame(width: 120, height: 100)
                            .foregroundColor(.gray).padding(.top, 60)
                            .onTapGesture { showImagePicker = true }
                        Text("Tap to Upload Poster")
                            .foregroundColor(.gray).font(.subheadline).padding(.top, 5)
                    }
                }
                .padding(.bottom, 30)
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $viewModel.selectedImage)
                }

                // FİLM ÖZETİ GİRİŞİ
                VStack(alignment: .leading, spacing: 10) {
                    Text("If you want a better prediction result, please add the plot summary of the movie in the field below")
                        .foregroundColor(.cyan).font(.title3).fontWeight(.medium)
                }
                .frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, 5)

                VStack(alignment: .leading, spacing: 15) {
                    TextEditor(text: $viewModel.summaryText) // viewModel.summaryText'e bağlı
                        .frame(height: 120)
                        .foregroundColor(Color(.darkGray)) // Metin rengi
                        .padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.7), lineWidth: 1))
                }
                .frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, 20)

                // NavigationLink'i OutputView'a göre güncelle
                NavigationLink(
                    destination: OutputView(
                        image: viewModel.selectedImage,
                        predictedGenres: viewModel.predictedGenresForOutput,
                        allProbabilities: viewModel.genreProbabilitiesForOutput // <<< BU ARGÜMAN
                    ),
                    isActive: $viewModel.showOutputView
                ) { EmptyView().frame(height: 0) } // EmptyView'ı gizle

                Button(action: {
                    viewModel.processForGenrePrediction() // Eski uploadPoster yerine bu çağrılacak
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity).padding()
                            .background(Color.cyan).cornerRadius(8)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white)) // Rengi beyaz yap
                    } else {
                        Text("Get Genre Prediction") // Buton metnini değiştirdim
                            .fontWeight(.semibold).foregroundColor(.white)
                            .padding().frame(maxWidth: .infinity)
                            .background( (viewModel.selectedImage != nil && !viewModel.summaryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ? Color.cyan : Color.gray.opacity(0.5) ) // Disable görünümü
                            .cornerRadius(8)
                    }
                }
                .padding(.bottom)
                .disabled(viewModel.selectedImage == nil || viewModel.summaryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)


                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Upload Poster").foregroundColor(.primary)
            }
        }
        .navigationTitle("") // Başlığı toolbar item'ı ile set ettiğimiz için bunu boşaltabiliriz
        // BaseViewModel'deki showToast fonksiyonu ve isShowingToast/toastMessage
        // değişkenlerini kullanarak bir toast modifier'ı bağlayın.
        // Örnek: .toast(isPresented: $viewModel.isShowingToast, message: viewModel.toastMessage ?? "Bir hata oluştu")
        // Veya kendi toast kütüphanenizi kullanın.
        // Şimdilik, BaseViewModel'deki showToast'un içindeki print yeterli olacaktır test için.
        // Veya basit bir alert:
        .alert(viewModel.toastMessage ?? "Bilinmeyen Hata", isPresented: $viewModel.isShowingToast) {
            Button("Tamam", role: .cancel) { }
        }
    }
}

struct PosterUploadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PosterUploadView()
        }
    }
}
