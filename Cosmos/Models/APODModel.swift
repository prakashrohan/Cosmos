//
//  APODModel.swift
//  Cosmos
//
//  Created by Rohan Prakash on 01/08/25.
//

import Foundation
import Combine

// MARK: - APOD Model
struct APOD: Decodable, Identifiable {
    // Fallback ID using UUID if date is missing
    var id: String { date ?? UUID().uuidString }
    
    let date: String?
    let title: String?
    let explanation: String?
    let url: String?
    let hdurl: String?
    let media_type: String?
    let thumbnail_url: String?

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
