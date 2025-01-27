//
//  PhotoInputView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 26/01/25.
//

import SwiftUI

struct PhotoInputView: View {
    @State private var selectedImage: UIImage?
    @State private var predictions: [Prediction] = []
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    private let predictor = CoreMLPrediction()

    var body: some View {
        VStack(spacing: 20) {
            Text("Select or Take a Photo")
                .font(.title2)
                .padding()

            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
                    .overlay(
                        Text("No Image Selected")
                            .foregroundColor(.gray)
                    )
            }

            if !predictions.isEmpty {
                PredictionDisplayView(
                    predictions: predictions,
                    onARButtonTap: { constellationName in
                        // Handle AR view action
                        print("View \(constellationName) in AR")
                        showARView(for: constellationName)
                    }
                )
                .padding()
            }

            HStack(spacing: 20) {
                Button(action: {
                    sourceType = .camera
                    showImagePicker = true
                }) {
                    Text("Take Photo")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    sourceType = .photoLibrary
                    showImagePicker = true
                }) {
                    Text("Upload Photo")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .frame(maxWidth: .infinity)

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(image: $selectedImage, sourceType: sourceType)
        }
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                predictor.predict(from: image) { results in
                    predictions = results.map { Prediction(label: $0.identifier, confidence: Double($0.confidence)) }
                }
            }
        }
    }

    func showARView(for constellationName: String) {
        // Navigate to AR View Placeholder
        let arView = ARViewPlaceholder(constellationName: constellationName)
        let controller = UIHostingController(rootView: arView)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(controller, animated: true, completion: nil)
        }
    }
}
struct ARViewPlaceholder: View {
    let constellationName: String

    var body: some View {
        VStack {
            Text("AR View for \(constellationName.capitalized)")
                .font(.largeTitle)
                .padding()

            Text("This is where the AR experience will be implemented.")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.9))
        .foregroundColor(.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
