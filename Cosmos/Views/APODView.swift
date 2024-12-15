import SwiftUI
import Combine
import ARKit
import SceneKit

struct APODView: View {
    @State private var apod: APOD?
    @State private var cancellable: AnyCancellable?
    @State private var showAR = false // Toggle AR View

    var body: some View {
        VStack {
            if showAR {
                // Display AR View with APOD Image
                if let imageURL = apod?.hdurl ?? apod?.url {
                    ARAPODView(imageURL: imageURL)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Text("No Image URL Available")
                        .foregroundColor(.red)
                        .padding()
                }
            } else {
                // Standard APOD View
                if let apod = apod {
                    if apod.media_type == "image" {
                        AsyncImage(url: URL(string: apod.url ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                    } else if apod.media_type == "video" {
                        VideoPlayerView(urlString: apod.url ?? "")
                    }

                    Text(apod.title ?? "No Title")
                        .font(.title)
                        .padding()
                    Text(apod.explanation ?? "No Explanation")
                        .padding()
                } else {
                    ProgressView("Loading...")
                }

                // Button to toggle AR View
                Button(action: {
                    withAnimation {
                        showAR.toggle()
                    }
                }) {
                    Text(showAR ? "Exit AR" : "View in AR")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .onAppear {
            cancellable = NASAService.shared.fetchAPOD()
                .sink(receiveCompletion: { print($0) },
                      receiveValue: { self.apod = $0 })
        }
    }
}

// MARK: - AR View to Display APOD Image as a 3D Floating Plane
struct ARAPODview: UIViewRepresentable {
    let imageURL: String

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.scene = SCNScene()
        arView.automaticallyUpdatesLighting = true

        // Start AR session
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)

        // Load the APOD image and display it in AR
        addImageToScene(arView: arView, imageURL: imageURL)

        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    private func addImageToScene(arView: ARSCNView, imageURL: String) {
        // Fetch the image
        guard let url = URL(string: imageURL),
              let imageData = try? Data(contentsOf: url),
              let image = UIImage(data: imageData) else {
            print("Failed to load APOD image.")
            return
        }

        // Create a plane with the APOD image
        let plane = SCNPlane(width: 1.5, height: 1.0) // Adjust size as needed
        plane.firstMaterial?.diffuse.contents = image
        plane.firstMaterial?.isDoubleSided = true

        // Create a node and place it 2 meters in front of the user
        let node = SCNNode(geometry: plane)
        node.position = SCNVector3(0, 0, -2)

        // Add a rotation animation for interactivity
        let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat.pi, z: 0, duration: 10))
        node.runAction(rotateAction)

        // Add the node to the AR scene
        arView.scene.rootNode.addChildNode(node)
    }
}

// MARK: - Video Player View (For APOD Videos)
import AVKit

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
