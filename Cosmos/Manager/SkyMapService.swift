import Foundation

class SkyMapService {
    private let baseURL = "https://api.astronomyapi.com/api/v2/studio/star-chart"
    private let applicationID = "d78a61a2-3933-4cde-ae5a-88b6b3cdf088"
    private let applicationSecret = "c59e5e1b75005e1aed74c11bdd509b96b17c2e30998221076dda40b4ca848e71c616d8d3e7ced565b27dab43eb7eaac28685dbe4a5dedec17a00a9929cf2f97147df8af03b99b1b540f985baa80e862819d032ba8af2ba06a7e0504722f356efabf122082eb3df0843e34efa7e139263" 

   
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
