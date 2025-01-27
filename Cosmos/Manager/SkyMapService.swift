//
//  SkyMapService.swift
//  Cosmos
//
//  Created by Rohan Prakash on 26/01/25.
//

import Foundation
import CoreLocation

class SkyMapService {
    private let apiKey = "05f0f563-5f7f-427a-a43f-f70d2886d7a4" // Replace with your key
    private let baseURL = "https://api.starmap.com/v1/constellations"

    func fetchConstellation(location: CLLocation, azimuth: Double, altitude: Double, completion: @escaping (String?) -> Void) {
        // Construct the API URL
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let urlString = "\(baseURL)?latitude=\(latitude)&longitude=\(longitude)&azimuth=\(azimuth)&altitude=\(altitude)&apiKey=\(apiKey)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            completion(nil)
            return
        }

        // Perform the API request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("API request failed: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }

            // Parse the response
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let constellation = json["constellation"] as? String {
                    completion(constellation)
                } else {
                    completion(nil)
                }
            } catch {
                print("Failed to parse JSON: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }
}

