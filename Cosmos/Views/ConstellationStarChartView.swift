//
//  ConstellationStarChartView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 28/01/25.
//


import SwiftUI

struct ConstellationStarChartView: View {
    @State private var starChartUrl: String? = nil
    @State private var isLoading = true

    var body: some View {
        VStack {
            Text("Constellation: Orion")
                .font(.title)
                .padding()

            if let starChartUrl = starChartUrl {
                AsyncImage(url: URL(string: starChartUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView("Loading star chart...")
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .cornerRadius(10)
                            .padding()
                    case .failure:
                        Text("Failed to load star chart.")
                            .foregroundColor(.red)
                    @unknown default:
                        Text("Unknown error occurred.")
                    }
                }
            } else if isLoading {
                ProgressView("Fetching star chart...")
                    .padding()
            } else {
                Text("No star chart available.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .onAppear {
            let skyMapService = SkyMapService()
            skyMapService.generateConstellationStarChart(
                latitude: 33.775867,
                longitude: -84.39733,
                date: "2025-01-29",
                constellationID: ""
            ) { imageUrl in
                DispatchQueue.main.async {
                    self.starChartUrl = imageUrl
                    self.isLoading = false
                }
            }
        }
    }
}
#Preview {
    ConstellationStarChartView()
}
