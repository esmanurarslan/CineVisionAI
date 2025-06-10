import SwiftUI

struct PosterUploadView: View {
    @StateObject private var viewModel = CloudViewModel()
    @State private var showImagePicker = false

    var body: some View {
        ZStack {
            // Arka Plan Gradient
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "#1B1525"), location: 0.0),
                    .init(color: Color(hex: "#1B1525"), location: 0.8),
                    .init(color: Color("myPurple"), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        // Görsel Seçme
                        ZStack {
                            VStack(spacing: 10) {
                                if let image = viewModel.selectedImage {
                                    Image(uiImage: image)
                                        .resizable().scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .cornerRadius(8).shadow(radius: 3)
                                        .padding(.top, 60)
                                        .onTapGesture { showImagePicker = true }
                                } else {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .resizable().scaledToFit()
                                        .frame(width: 120, height: 100)
                                        .foregroundColor(.white.opacity(0.4))
                                        .padding(.top, 60)
                                        .onTapGesture { showImagePicker = true }

                                    Text("Tap to Upload Poster")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.subheadline)
                                        .padding(.top, 5)
                                }
                            }
                            .padding(24)

                            SmallCornerOverlay()
                                .stroke(Color.white, lineWidth: 4)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(4)
                                .shadow(color: Color("myYellow").opacity(1), radius: 10)

                        }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(selectedImage: $viewModel.selectedImage)
                        }

                        // Açıklama
                        VStack(alignment: .leading, spacing: 10) {
                            Text("If you want a better prediction result, please add the plot summary of the movie in the field below")
                                .foregroundColor(Color("myYellow"))
                                .font(.system(size: 18, weight: .bold))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)

                        // TextEditor
                        VStack(alignment: .leading, spacing: 15) {
                            TextEditor(text: $viewModel.summaryText)
                                .frame(height: 280)
                                .padding(8)
                                .foregroundColor(Color("myYellow"))
                                .background(Color(hex: "#1B1525"))
                                .scrollContentBackground(.hidden)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        //.stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        .stroke(Color.white, lineWidth: 2)
                                        .shadow(color: Color("myYellow").opacity(1), radius: 10)

                                )
                        }
                        .padding(.bottom, 80) // Butondan uzak olsun
                    }
                    .padding()
                }

                // Buton Aşağı Sabit
                VStack {
                    NavigationLink(
                        destination: OutputView(
                            image: viewModel.selectedImage,
                            predictedGenres: viewModel.predictedGenresForOutput,
                            allProbabilities: viewModel.genreProbabilitiesForOutput
                        ),
                        isActive: $viewModel.showOutputView
                    ) { EmptyView().frame(height: 0) }

                    Button(action: {
                        viewModel.processForGenrePrediction()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("myYellow"))
                                .cornerRadius(8)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color("myPurple")))
                        } else {
                            Text("Get Genre Prediction")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("myPurple"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    (viewModel.selectedImage != nil && !viewModel.summaryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                    ? Color("myYellow")
                                    : Color.white.opacity(0.2)
                                )
                                .cornerRadius(12)
                                .shadow(
                                    color: (viewModel.selectedImage != nil && !viewModel.summaryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                        ? Color("myYellow") : Color.clear,
                                    radius: 8
                                )

                        }
                    }
                    .disabled(viewModel.selectedImage == nil || viewModel.summaryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                }
                .background(Color.black.opacity(0.001)) // scrollable içeriğe yapışmasın
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Upload Poster")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading)

            }
        }
        .navigationTitle("")
        .alert(viewModel.toastMessage ?? "Bilinmeyen Hata", isPresented: $viewModel.isShowingToast) {
            Button("Tamam", role: .cancel) { }
        }
    }
}

struct SmallCornerOverlay: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let length: CGFloat = 20

        // Sol üst
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + length))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + length, y: rect.minY))

        // Sağ üst
        path.move(to: CGPoint(x: rect.maxX - length, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + length))

        // Sağ alt
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - length))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - length, y: rect.maxY))

        // Sol alt
        path.move(to: CGPoint(x: rect.minX + length, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - length))

        return path
    }
}



struct PosterUploadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PosterUploadView()
        }
    }
}
