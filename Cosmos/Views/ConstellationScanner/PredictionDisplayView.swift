//
//  PredictionDisplayView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 26/01/25.
//

import SwiftUI

struct PredictionDisplayView: View {
    let predictions: [Prediction]
    let onARButtonTap: (String) -> Void // Callback for AR button action

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(predictions.filter { $0.confidence > 0.7 }, id: \.label) { prediction in
                HStack {
                    Text(prediction.label.capitalized)
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    
                    Spacer()

                    Button(action: {
                        onARButtonTap(prediction.label)
                    }) {
                        Text("View in AR")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}


struct Prediction {
    let label: String
    let confidence: Double // Value between 0.0 and 1.0
}


