//
//  MoonPhaseViewModel.swift
//  Cosmos
//
//  Created by Rohan Prakash on 17/07/25.
//


import Foundation
import Combine

class MoonPhaseViewModel: ObservableObject {
    @Published var moonImageURL: String?
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    func fetchMoonPhase(latitude: Double, longitude: Double, date: String) {
        isLoading = true
        let url = URL(string: "https://api.astronomyapi.com/api/v2/studio/moon-phase")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 🔑 Replace with your real credentials
        let credentials = "\(skyAsset.skymapApplicationID):\( skyAsset.skymapApplicationSecreet)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "format": "png",
            "style": [
                "moonStyle": "sketch",
                "backgroundStyle": "stars",
                "backgroundColor": "#000000",
                "headingColor": "#FFFFFF",
                "textColor": "#CCCCCC"
            ],
            "observer": [
                "latitude": latitude,
                "longitude": longitude,
                "date": date
            ],
            "view": [
                "type": "portrait-simple",
                "orientation": "south-up"
            ]
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: MoonPhaseResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in self.isLoading = false },
                  receiveValue: { [weak self] response in
                self?.moonImageURL = response.data.imageUrl
            })
            .store(in: &cancellables)
    }
}

struct MoonPhaseResponse: Codable {
    let data: MoonImageData
}

struct MoonImageData: Codable {
    let imageUrl: String
}
