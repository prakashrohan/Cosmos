//
//  ARAPODView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 15/12/24.
//


import SwiftUI
import ARKit
import SceneKit

struct ARAPODView: UIViewRepresentable {
    let imageURL: String

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.scene = SCNScene()
        arView.automaticallyUpdatesLighting = true

        // Start AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        arView.session.run(configuration)

        // Load the APOD image and add it to the scene
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
