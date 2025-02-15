//
//  new.swift
//  Cosmos
//
//  Created by Rohan Prakash on 25/01/25.
//
//
//import SwiftUI
//import ARKit
//import RealityKit
//
//struct ARViewContainer: UIViewRepresentable {
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        
//        // Setup AR session for plane detection
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = [.horizontal]
//        arView.session.run(config)
//        
//        // Tap gesture for placing the model
//        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
//        arView.addGestureRecognizer(tapGesture)
//        
//        context.coordinator.arView = arView
//        return arView
//    }
//    
//    func updateUIView(_ uiView: ARView, context: Context) {}
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator()
//    }
//    
//    class Coordinator: NSObject {
//        var arView: ARView?
//        
//        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
//            guard let arView = arView else { return }
//            let location = gesture.location(in: arView)
//            
//            // Perform a hit test to find a plane
//            let results = arView.hitTest(location, types: [.existingPlaneUsingExtent])
//            if let firstResult = results.first {
//                placeModel(at: firstResult.worldTransform)
//            }
//        }
//        
//        func placeModel(at transform: simd_float4x4) {
//            guard let arView = arView else { return }
//            do {
//                let modelEntity = try Entity.loadModel(named: "ISS_stationary")
//                let anchorEntity = AnchorEntity(world: transform)
//                anchorEntity.addChild(modelEntity)
//                arView.scene.addAnchor(anchorEntity)
//            } catch {
//                print("Error loading model: \(error)")
//            }
//        }
//    }
//}
