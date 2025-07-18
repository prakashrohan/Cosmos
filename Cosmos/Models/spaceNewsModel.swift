//
//  SpaceNewsResponse.swift
//  Cosmos
//
//  Created by Rohan Prakash on 19/07/25.
//

import SwiftUI
import Combine
import SafariServices
struct SpaceNewsResponse: Codable {
    let results: [Article]
}

struct Article: Identifiable, Codable {
    let id: Int
    let title: String
    let url: String
    let image_url: String?
    let news_site: String
    let summary: String
    let published_at: String      // ISO‑8601 yyyy‑MM‑dd…
}
