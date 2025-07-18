//
//  test.swift
//  Cosmos
//
//  Created by Rohan Prakash on 24/01/25.
//

import SwiftUI
import ARKit
import SceneKit

// MARK: - AR Image View
struct ARImageView: UIViewRepresentable {
    let imageURL: String

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.scene = SCNScene()
        arView.automaticallyUpdatesLighting = true

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)

        addImageToScene(arView: arView, imageURL: imageURL)
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    private func addImageToScene(arView: ARSCNView, imageURL: String) {
        guard let url = URL(string: imageURL),
              let imageData = try? Data(contentsOf: url),
              let image = UIImage(data: imageData) else {
            print("❌ Failed to load image.")
            return
        }

        let plane = SCNPlane(width: 1.2, height: 0.8)
        plane.firstMaterial?.diffuse.contents = image
        plane.firstMaterial?.isDoubleSided = true

        let node = SCNNode(geometry: plane)
        node.position = SCNVector3(0, 0, -1.5)
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat.pi, z: 0, duration: 12))
        node.runAction(rotate)

        arView.scene.rootNode.addChildNode(node)
    }
}

// MARK: - Main Test View
struct TestView: View {
    @StateObject var networkManager = NetworkManager()
    @State private var selectedImageURL: String?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.05, blue: 0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                // Back button
                HStack {
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

                    Text("Mars Rover Explorer")
                        .font(.title2.bold())
                        .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)

                if let selectedImageURL = selectedImageURL {
                    ARImageView(imageURL: selectedImageURL)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(networkManager.photos) { photo in
                                VStack(alignment: .leading, spacing: 8) {
                                    Button(action: {
                                        selectedImageURL = photo.img_src.replacingOccurrences(of: "http:", with: "https:")
                                    }) {
                                        AsyncImage(url: URL(string: photo.img_src.replacingOccurrences(of: "http:", with: "https:"))) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(12)
                                                .shadow(radius: 5)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("📸 Camera: \(photo.camera.full_name)")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("🚀 Rover: \(photo.rover.name) (\(photo.rover.status.capitalized))")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8))
                                        Text("📅 Taken on: \(photo.earth_date)")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(20)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            networkManager.fetchPhotos()
        }
    }
}

// MARK: - Preview
#Preview {
    TestView()
}

