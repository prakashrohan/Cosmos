//
//  test.swift
//  Cosmos
//
//  Created by Rohan Prakash on 24/01/25.
//

import SwiftUI
import ARKit
import SceneKit

// MARK: - AR Image Viewing in AR
struct ARImageView: UIViewRepresentable {
    let imageURL: String

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.scene = SCNScene()
        arView.automaticallyUpdatesLighting = true

        // Start AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        arView.session.run(configuration)

        // Load the selected image and add it to the scene
        addImageToScene(arView: arView, imageURL: imageURL)

        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    private func addImageToScene(arView: ARSCNView, imageURL: String) {
        guard let url = URL(string: imageURL),
              let imageData = try? Data(contentsOf: url),
              let image = UIImage(data: imageData) else {
            print("Failed to load image.")
            return
        }

        // Create a plane geometry to display the image
        let plane = SCNPlane(width: 1.5, height: 1.0) // Adjust dimensions as needed
        plane.firstMaterial?.diffuse.contents = image
        plane.firstMaterial?.isDoubleSided = true

        // Create a node with the plane
        let node = SCNNode(geometry: plane)
        node.position = SCNVector3(0, 0, -2) // Place it 2 meters in front of the camera

        // Add a slight rotation animation for interactivity
        let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat.pi, z: 0, duration: 10))
        node.runAction(rotateAction)

        // Add the node to the AR scene
        arView.scene.rootNode.addChildNode(node)
    }
}

// MARK: - Model for Mars Rover API Response
struct MarsPhoto: Identifiable, Codable {
    let id: Int
    let img_src: String
    let earth_date: String
    let camera: Camera
    let rover: Rover

    struct Camera: Codable {
        let full_name: String
    }

    struct Rover: Codable {
        let name: String
        let status: String
    }
}

// MARK: - NetworkManager to Fetch Data
class NetworkManager: ObservableObject {
    @Published var photos: [MarsPhoto] = []

    func fetchPhotos() {
        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=2015-6-3&api_key=DEMO_KEY"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        let response = try JSONDecoder().decode([String: [MarsPhoto]].self, from: data)
                        self.photos = response["photos"] ?? []
                    } catch {
                        print("Decoding error:", error)
                    }
                }
            }
        }.resume()
    }
}

// MARK: - TestView with Image Display & AR Viewing
struct TestView: View {
    @StateObject var networkManager = NetworkManager()
    @State private var selectedImageURL: String?

    var body: some View {
        NavigationView {
            VStack {
                // Display AR view if an image is selected
                if let selectedImageURL = selectedImageURL {
                    ARImageView(imageURL: selectedImageURL)
                        .edgesIgnoringSafeArea(.all) // Make the AR view take the entire screen
                } else {
                    List(networkManager.photos) { photo in
                        VStack(alignment: .leading) {
                            // MARK: - Tap to Open Image in AR
                            Button(action: {
                                self.selectedImageURL = photo.img_src.replacingOccurrences(of: "http:", with: "https:") 
                                    
                                
                            }) {
                                AsyncImage(url: URL(string: photo.img_src.replacingOccurrences(of: "http:", with: "https:"))) { image in
                                    image.resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(height: 200)
                            }

                            Text("Camera: \(photo.camera.full_name)")
                                .font(.headline)
                            Text("Rover: \(photo.rover.name) (\(photo.rover.status.capitalized))")
                                .font(.subheadline)
                            Text("Taken on: \(photo.earth_date)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                    .navigationTitle("Mars Rover Photos")
                    .onAppear {
                        networkManager.fetchPhotos()
                    }
                }
            }
        }
    }
}

// MARK: - Preview for SwiftUI
struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
