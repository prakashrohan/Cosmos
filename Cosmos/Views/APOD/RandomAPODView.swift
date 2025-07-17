//
//  RandomAPODView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 15/12/24.
//

import SwiftUI
import Combine
import Photos


struct RandomAPODView: View {
    @State private var apods: [APOD] = []
    @State private var cancellable: AnyCancellable?
    @State private var isFetching = false  // Controls fetching animation
    @State private var showDetails = false
    @State private var isDownloading = false
    @State private var downloadSuccess: Bool?
    @Namespace private var animation

    var body: some View {
        ZStack {
            // 🌌 Aurora-Themed Background
            AuroraBackgroundView()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // 🌠 Title
                Text("Explore the Universe")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .shadow(color: .cyan.opacity(0.8), radius: 10, x: 0, y: 4)
                    .padding(.top, 20)

                // 🚀 Glassmorphic Fetch Button
                CustomGlassButton(action: fetchRandomAPODs, title: isFetching ? "Fetching..." : "Fetch APODs", isLoading: isFetching)

                // 🖼 APOD Results List
                if apods.isEmpty {
                    if !isFetching {
                        Text("No images yet.\nTap the button above to explore space!")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.top, 20)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(apods) { apod in
                                APODCard(apod: apod, animation: animation)
                                    .padding(.horizontal)
                                    .transition(.slide.combined(with: .opacity))
                            }

                        }
                    }
                    .padding(.top, 10)
                    .scrollIndicators(.hidden)
                }

                Spacer()
            }
            .padding(.bottom, 5)
            
        }
        .navigationTitle("APOD Explorer")
    }

    // MARK: - Fetch APODs
    private func fetchRandomAPODs() {
        isFetching = true
        apods.removeAll()

        cancellable = NASAService.shared.fetchRandomAPOD(count: 5)
            .sink(receiveCompletion: { completion in
                print(completion)
                DispatchQueue.main.async {
                    self.isFetching = false
                }
            }, receiveValue: { fetchedAPODs in
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        self.apods = fetchedAPODs
                    }
                    self.isFetching = false
                }
            })
    }
}

// MARK: - 🚀 Custom Glassmorphic Button
struct CustomGlassButton: View {
    let action: () -> Void
    let title: String
    var isLoading: Bool = false

    var body: some View {
        Button(action: {
            if !isLoading {
                action()
            }
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    BlurView(style: .systemUltraThinMaterialDark) // Frosted glass effect
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(LinearGradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.8)], startPoint: .leading, endPoint: .trailing), lineWidth: 2)
                        .shadow(color: Color.blue.opacity(0.6), radius: 10, x: 0, y: 4)
                        .blendMode(.overlay)
                }
            )
            .cornerRadius(15)
            .shadow(color: Color.blue.opacity(0.4), radius: 5, x: 0, y: 4)
            .padding(.horizontal, 40)
        }
        .animation(.spring(), value: isLoading)
    }
}

import Photos

struct aAPODCard: View {
    let apod: APOD
    @State private var showDetails = false
    @State private var isDownloading = false
    @State private var downloadSuccess: Bool?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 📌 Title
            Text(apod.title ?? "Untitled")
                .font(.headline)
                .foregroundColor(.white)
                .shadow(radius: 5)

            // 🖼 Image
            if let urlString = apod.url, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .cornerRadius(10)
                .shadow(radius: 5)

                // 📥 Download Button
                Button(action: {
                    downloadImage(from: url)
                }) {
                    HStack {
                        Image(systemName: "arrow.down.to.line")
                        Text(isDownloading ? "Downloading..." : "Download")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(10)
                }
                .padding(.top, 5)
                .disabled(isDownloading)
                .alert(isPresented: Binding<Bool>(
                    get: { downloadSuccess != nil },
                    set: { _ in downloadSuccess = nil }
                )) {
                    Alert(
                        title: Text(downloadSuccess == true ? "Success" : "Error"),
                        message: Text(downloadSuccess == true ? "Image saved to Photos!" : "Failed to save image."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            } else {
                Text("No valid image URL")
                    .foregroundColor(.white.opacity(0.8))
            }

            // 🔽 Expandable Details Section
            if let explanation = apod.explanation {
                Button(action: {
                    withAnimation {
                        showDetails.toggle()
                    }
                }) {
                    HStack {
                        Text(showDetails ? "Hide Details" : "View Details")
                        Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                    }
                    .foregroundColor(.cyan)
                    .padding(.top, 5)
                }

                if showDetails {
                    Text(explanation)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding()
                        .background(BlurView(style: .systemUltraThinMaterialDark))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .transition(.opacity)
                }
            }
        }
        .padding()
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .cornerRadius(15)
        .shadow(radius: 10)
    }

    // MARK: - 📥 Image Download Logic
    private func downloadImage(from url: URL) {
        isDownloading = true

        DispatchQueue.global(qos: .background).async {
            if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    downloadSuccess = true
                    isDownloading = false
                }
            } else {
                DispatchQueue.main.async {
                    downloadSuccess = false
                    isDownloading = false
                }
            }
        }
    }
}



struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        path.move(to: CGPoint(x: 0, y: height * 0.6))
        path.addCurve(to: CGPoint(x: width, y: height * 0.6),
                      control1: CGPoint(x: width * 0.35, y: height * 0.4),
                      control2: CGPoint(x: width * 0.65, y: height * 0.8))

        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}
// MARK: - 🌌 Aurora-Themed Background
struct AuroraBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.6), Color.purple.opacity(0.5)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
        .overlay(
            ZStack {
                Color.black.opacity(0.3)
                VStack {
                    Spacer()
                    WaveShape()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 200)
                        .opacity(0.8)
                }
            }
        )
    }
}




// MARK: - 📸 Preview
struct RandomAPODView_Previews: PreviewProvider {
    static var previews: some View {
        RandomAPODView()
    }
}
