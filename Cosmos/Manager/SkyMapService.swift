import Foundation

class SkyMapService {
    private let baseURL = "https://api.astronomyapi.com/api/v2/studio/star-chart"
    private let applicationID = skyAsset.skymapApplicationID
    private let applicationSecret = skyAsset.skymapApplicationSecreet

   
    func generateConstellationStarChart(
        latitude: Double,
        longitude: Double,
        date: String,
        constellationID: String,
        completion: @escaping (String?) -> Void
    ) {
        // Request body for constellation
        let requestBody: [String: Any] = [
            "style": "inverted",
            "observer": [
                "latitude": latitude,
                "longitude": longitude,
                "date": date
            ],
            "view": [
                "type": "constellation",
                "parameters": [
                    "constellation": constellationID // 3-letter constellation ID
                ]
            ]
        ]

        // Construct the request URL
        guard let url = URL(string: baseURL) else {
            print("Invalid URL.")
            completion(nil)
            return
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add Authorization header
        let credentials = "\(applicationID):\(applicationSecret)"
        if let encodedCredentials = credentials.data(using: .utf8)?.base64EncodedString() {
            request.addValue("Basic \(encodedCredentials)", forHTTPHeaderField: "Authorization")
        } else {
            print("Failed to encode credentials.")
            completion(nil)
            return
        }

        // Add JSON body to the request
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
        } catch {
            print("Failed to encode request body: \(error)")
            completion(nil)
            return
        }

        // Perform the API request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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

            // Debug: Print raw response
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw Response: \(rawResponse)")
            }

            // Parse the response
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let dataObject = json["data"] as? [String: Any],
                   let imageUrl = dataObject["imageUrl"] as? String {
                    completion(imageUrl) // Return the image URL
                } else {
                    print("Unexpected response format.")
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
