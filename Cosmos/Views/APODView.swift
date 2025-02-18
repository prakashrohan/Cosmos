import SwiftUI
import Combine
import ARKit
import SceneKit
import AVKit

struct APODView: View {
    @State private var apod: APOD?
    @State private var cancellable: AnyCancellable?
    @State private var showAR = false // Toggle AR View

    var body: some View {
        ZStack {
            // 🔵 Space Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.3)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                if showAR {
                    // 🌌 AR View with APOD Image
                    if let imageURL = apod?.hdurl ?? apod?.url {
                        ARAPODView(imageURL: imageURL)
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        Text("No Image URL Available")
                            .foregroundColor(.red)
                            .padding()
                    }
                } else {
                    // 📷 APOD Image / Video View
                    if let apod = apod {
                        VStack(spacing: 15) {
                            if apod.media_type == "image" {
                                AsyncImage(url: URL(string: apod.url ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(12)
                                        .shadow(radius: 8)
                                        .padding()
                                } placeholder: {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(1.5)
                                        .padding()
                                }
                            } else if apod.media_type == "video" {
                                VideoPlayerView(urlString: apod.url ?? "")
                                    .cornerRadius(12)
                                    .shadow(radius: 8)
                                    .padding()
                            }

                            // 📜 APOD Title
                            Text(apod.title ?? "No Title")
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .shadow(color: .blue.opacity(0.8), radius: 5, x: 0, y: 3)
                                .padding(.horizontal)

                            // 📝 APOD Explanation
                            ScrollView {
                                Text(apod.explanation ?? "No Explanation Available")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding()
                                    .background(BlurView(style: .systemUltraThinMaterialDark))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                            .frame(height: 180)

                            // 🚀 AR Toggle Button
                            Button(action: {
                                withAnimation {
                                    showAR.toggle()
                                }
                            }) {
                                Text(showAR ? "Exit AR Mode" : "View in AR")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)]),
                                                               startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(12)
                                    .shadow(radius: 8)
                            }
                            .padding(.horizontal, 30)
                            .padding(.bottom, 20)
                        }
                        .padding()
                        .background(BlurView(style: .systemUltraThinMaterialDark))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding(.horizontal, 20)
                    } else {
                        ProgressView("Loading APOD...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                            .padding()
                    }
                }
            }
        }
        .onAppear {
            cancellable = NASAService.shared.fetchAPOD()
                .sink(receiveCompletion: { print($0) },
                      receiveValue: { self.apod = $0 })
        }
    }
}

// MARK: - 🌌 AR View (Floating APOD Image)
struct aRAPODView: UIViewRepresentable {
    let imageURL: String

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.scene = SCNScene()
        arView.automaticallyUpdatesLighting = true

        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)

        addImageToScene(arView: arView, imageURL: imageURL)

        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    private func addImageToScene(arView: ARSCNView, imageURL: String) {
        guard let url = URL(string: imageURL),
              let imageData = try? Data(contentsOf: url),
              let image = UIImage(data: imageData) else {
            print("Failed to load APOD image.")
            return
        }

        let plane = SCNPlane(width: 1.5, height: 1.0)
        plane.firstMaterial?.diffuse.contents = image
        plane.firstMaterial?.isDoubleSided = true

        let node = SCNNode(geometry: plane)
        node.position = SCNVector3(0, 0, -2)

        let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat.pi, z: 0, duration: 10))
        node.runAction(rotateAction)

        arView.scene.rootNode.addChildNode(node)
    }
}

// MARK: - 📽 Video Player for APOD Videos
struct VideoPlayerView: View {
    let urlString: String

    var body: some View {
        if let url = URL(string: urlString) {
            VideoPlayer(player: AVPlayer(url: url))
                .frame(height: 300)
        } else {
            Text("Unable to load video.")
                .foregroundColor(.red)
        }
    }
}



// MARK: - 📸 Preview
struct APODView_Previews: PreviewProvider {
    static var previews: some View {
        APODView()
    }
}
