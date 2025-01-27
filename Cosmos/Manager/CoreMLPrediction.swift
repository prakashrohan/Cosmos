//
//  Untitled.swift
//  Cosmos
//
//  Created by Rohan Prakash on 26/01/25.
//
import CoreML
import Vision
import UIKit

class CoreMLPrediction {
    private let model: VNCoreMLModel

    init() {
        // Load the Core ML model
        let mlModel = try! MULTICONSTELLATIONS_1(configuration: MLModelConfiguration())
        model = try! VNCoreMLModel(for: mlModel.model)
    }

    func predict(from image: UIImage, completion: @escaping ([VNClassificationObservation]) -> Void) {
        // Convert UIImage to CIImage
        guard let ciImage = CIImage(image: image) else {
            completion([])
            return
        }

        // Create a request for the Core ML model
        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                print("Error making prediction: \(error)")
                completion([])
                return
            }

            // Process the prediction results
            if let results = request.results as? [VNClassificationObservation] {
                completion(results)
            } else {
                completion([])
            }
        }

        // Perform the request
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Error performing request: \(error)")
            completion([])
        }
    }
}

