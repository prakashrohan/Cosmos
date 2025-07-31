//
//  APOD.swift
//  Cosmos
//
//  Created by Rohan Prakash on 15/12/24.
//


import Foundation
import Combine



class NASAService {
    static let shared = NASAService()
    private let apiKey = nasaService.APIKey

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
