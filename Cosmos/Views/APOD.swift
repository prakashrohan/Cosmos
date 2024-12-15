//
//  APOD.swift
//  Cosmos
//
//  Created by Rohan Prakash on 15/12/24.
//


import Foundation
import Combine

// MARK: - APOD Model
struct APOD: Decodable, Identifiable {
    // Fallback ID using UUID if date is missing
    var id: String { date ?? UUID().uuidString }
    
    let date: String? // Optional to handle missing date
    let title: String? // Optional to handle missing title
    let explanation: String? // Optional for missing explanation
    let url: String? // Image URL
    let hdurl: String? // High-resolution image URL
    let media_type: String? // "image" or "video"
    let thumbnail_url: String? // Optional thumbnail for videos

    // CodingKeys for JSON decoding
    enum CodingKeys: String, CodingKey {
        case date, title, explanation, url, hdurl, media_type, thumbnail_url
    }

    // Custom initializer to log missing keys
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Safe decoding with logging for missing fields
        self.date = try? container.decodeIfPresent(String.self, forKey: .date)
        self.title = try? container.decodeIfPresent(String.self, forKey: .title)
        self.explanation = try? container.decodeIfPresent(String.self, forKey: .explanation)
        self.url = try? container.decodeIfPresent(String.self, forKey: .url)
        self.hdurl = try? container.decodeIfPresent(String.self, forKey: .hdurl)
        self.media_type = try? container.decodeIfPresent(String.self, forKey: .media_type)
        self.thumbnail_url = try? container.decodeIfPresent(String.self, forKey: .thumbnail_url)

        // Log any missing critical fields
        if title == nil {
            print("⚠️ Warning: 'title' key is missing in the API response.")
        }
        if url == nil {
            print("⚠️ Warning: 'url' key is missing in the API response.")
        }
    }
}

// MARK: - APOD Service (API Handling)
class NASAService {
    static let shared = NASAService()
    private let apiKey = "4zw9zRvjFuTbpRiREwYUd5lbgM4e4v8w3RJZQRgu"

    // Fetch APOD for a single date
    func fetchAPOD(for date: String? = nil) -> AnyPublisher<APOD, Error> {
        // Construct URL with optional date
        var urlString = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)"
        if let date = date {
            urlString += "&date=\(date)"
        }
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        // API request with error handling
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result in
                // Check for non-200 responses
                guard let response = result.response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: APOD.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Fetch APOD for a date range
    func fetchAPODRange(startDate: String, endDate: String) -> AnyPublisher<[APOD], Error> {
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&start_date=\(startDate)&end_date=\(endDate)"
        let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [APOD].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // Fetch random APOD images
    func fetchRandomAPOD(count: Int) -> AnyPublisher<[APOD], Error> {
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&count=\(count)"
        let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [APOD].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
