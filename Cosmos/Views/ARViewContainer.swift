//
//  ARViewContainer.swift
//  Cosmos
//
//  Created by Rohan Prakash on 26/01/25.
//


import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    let usdzFileName: String

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)

        // Add coaching overlay for user guidance
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = arView.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        arView.addSubview(coachingOverlay)

        // Setup ARView for the model
        context.coordinator.setupARView(arView: arView, usdzFileName: usdzFileName)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        var arView: ARView?
        var modelEntity: ModelEntity?

        func setupARView(arView: ARView, usdzFileName: String) {
            self.arView = arView

            // Load the USDZ model
            guard let modelEntity = try? ModelEntity.loadModel(named: usdzFileName) else {
                print("Failed to load \(usdzFileName).")
                return
            }
            self.modelEntity = modelEntity

            // Set up anchor for placement
            let anchorEntity = AnchorEntity(plane: .horizontal)
            anchorEntity.addChild(modelEntity)
            arView.scene.addAnchor(anchorEntity)

            // Hide model initially
            modelEntity.isEnabled = false

            // Set up tap gesture for placement
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            arView.addGestureRecognizer(tapGesture)
        }

        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = arView, let modelEntity = modelEntity else { return }

            let tapLocation = sender.location(in: arView)
            let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)

            if let firstResult = results.first {
                let transform = Transform(matrix: firstResult.worldTransform)
                modelEntity.transform = transform
                modelEntity.isEnabled = true
            }
        }
    }
}
