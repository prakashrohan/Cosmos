//
//  marsRover.swift
//  Cosmos
//
//  Created by Rohan Prakash on 17/07/25.
//

import Foundation

class NetworkManager: ObservableObject {
    @Published var photos: [MarsPhoto] = []

    func fetchPhotos() {
        let urlString = marsRover.APIKey
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        let response = try JSONDecoder().decode([String: [MarsPhoto]].self, from: data)
                        self.photos = response["photos"] ?? []
                    } catch {
                        print("Decoding error:", error)
                    }
                }
            }
        }.resume()
    }
}
