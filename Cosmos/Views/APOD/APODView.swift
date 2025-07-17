import SwiftUI
import Combine
import ARKit
import SceneKit
import AVKit

struct APODView: View {
    @State private var apod: APOD?
    @State private var cancellable: AnyCancellable?
    @State private var showAR = false
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        NavigationStack{
            
            ZStack {
                // 🌌 Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.05, blue: 0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    
                    
                    HStack (spacing:16){
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium))
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                                
                        }
                        
                        .padding(.leading,-4)
                        .padding(.top, -10) // Enough space for notch/safe area
                    
                        // 🪐 Title
                        Text("Astronomy Picture of the Day")
                            .font(.largeTitle.bold())
                            .foregroundStyle(LinearGradient(
                                colors: [Color.purple, Color.blue],
                                startPoint: .leading, endPoint: .trailing)
                            )
                            .shadow(color: .blue.opacity(0.5), radius: 10)
                    }
                    .padding(.top, -30)
                    .padding(.horizontal, 24)

                    if let apod = apod {
                        if showAR {
                            ARAPODView(imageURL: apod.hdurl ?? apod.url ?? "")
                                .edgesIgnoringSafeArea(.all)
                        } else {
                            ScrollView {
                                VStack(spacing: 16) {
                                    // 🌠 Image or Video
                                    if apod.media_type == "image" {
                                        AsyncImage(url: URL(string: apod.url ?? "")) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(16)
                                                .shadow(color: .blue.opacity(0.4), radius: 8)
                                                .padding(.horizontal)
                                        } placeholder: {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                .scaleEffect(1.2)
                                                .padding()
                                        }
                                    } else if apod.media_type == "video" {
                                        VideoPlayerView(urlString: apod.url ?? "")
                                            .cornerRadius(16)
                                            .padding(.horizontal)
                                    }

                                    // 📌 Title
                                    Text(apod.title ?? "Untitled")
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                        .shadow(color: .blue.opacity(0.6), radius: 6)

                                    // 📖 Explanation
                                    Text(apod.explanation ?? "No explanation available.")
                                        .font(.body)
                                        .foregroundColor(.white.opacity(0.85))
                                        .padding()
                                        .background(BlurView(style: .systemThinMaterialDark))
                                        .cornerRadius(16)
                                        .padding(.horizontal)
                                }
                            }
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }

                        // 🎛 AR Toggle Button
                        Button {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showAR.toggle()
                            }
                        } label: {
                            Text(showAR ? "Exit AR Mode" : "View in AR")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        colors: [Color.blue, Color.purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(radius: 8)
                                .padding(.horizontal, 30)
                        }
                        .padding(.top, 10)
                        .transition(.scale)
                    } else {
                        ProgressView("Loading APOD...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                            .padding(.top, 60)
                    }
                }
                .padding(.top, 50)
            }
            .onAppear {
                cancellable = NASAService.shared.fetchAPOD()
                    .sink(receiveCompletion: { print($0) },
                          receiveValue: { self.apod = $0 })
            }
            .onAppear { appState.isTabBarHidden = true }
                .onDisappear { appState.isTabBarHidden = false }
            .navigationBarBackButtonHidden(true)
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
            .environmentObject(AppState()) // Injecting required environment object
            .preferredColorScheme(.dark)
    }
}

