//
//  CoreMLPrediction.swift
//  Cosmos
//
//  Created by Rohan Prakash on 26 Jan 25.
//

import CoreML
import Vision
import UIKit


final class CoreMLPrediction {
    private let vnModel: VNCoreMLModel

    init() {
        // ⬇️  load your .mlmodel
        let mlModel = try! MULTICONSTELLATIONS_1(configuration: MLModelConfiguration())
        vnModel = try! VNCoreMLModel(for: mlModel.model)
    }

    // Run a Vision classification request and return results on the main queue.
    func predict(from image: UIImage,
                 completion: @escaping ([VNClassificationObservation]) -> Void)
    {
        // CIImage + correct orientation
        guard
            let ciImage = CIImage(image: image),
            let orientation = CGImagePropertyOrientation(image.imageOrientation)
        else {
            completion([])
            return
        }

        // Build Vision request
        let request = VNCoreMLRequest(model: vnModel) { req, error in
            if let error = error {
                print("Vision error:", error.localizedDescription)
                DispatchQueue.main.async { completion([]) }
                return
            }

            let results = req.results as? [VNClassificationObservation] ?? []
            DispatchQueue.main.async { completion(results) }   // ✅ main thread
        }

        // Perform on background queue
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage,
                                                orientation: orientation)
            do {
                try handler.perform([request])
            } catch {
                print("Handler error:", error.localizedDescription)
                DispatchQueue.main.async { completion([]) }
            }
        }
    }
}

