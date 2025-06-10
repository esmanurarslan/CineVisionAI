
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            // Arka planı gradient yapalım ki Sign In sayfasıyla uyumlu olsun
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

            // Beyaz çizgili köşe çerçevesi
            CornerOverlay()
                .stroke(Color.white, lineWidth: 8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 90)
                .padding(.horizontal, 40)
                .shadow(color: Color("myYellow").opacity(0.7), radius: 8)

            VStack(spacing: 24) {
                Spacer()

                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: Color("myYellow").opacity(0.5), radius: 8, x: 0, y: 4)

                VStack(spacing: 10) {
                    Text("Welcome to CineVisionAI")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("myYellow"))

                    Text("Upload a poster and a short summary.\nWe’ll help you discover the genre behind it.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                }

                NavigationLink(destination: PosterUploadView()) {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("myYellow"))
                        )
                        .foregroundColor(Color("myPurple"))
                        .padding(.horizontal, 32)
                        .shadow(color: Color("myYellow").opacity(0.5), radius: 5, x: 0, y: 3)
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}



struct CornerOverlay: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let length: CGFloat = 30

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
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WelcomeView()
        }
    }
}
