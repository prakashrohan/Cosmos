//
//  SpaceNewsService.swift
//  Cosmos
//
//  Created by Rohan Prakash on 19/07/25.
//

import SwiftUI
import Combine
import SafariServices


final class SpaceNewsService: ObservableObject {
    @Published var articles: [Article] = []

    private var bag = Set<AnyCancellable>()
    private let endpoint = "https://api.spaceflightnewsapi.net/v4/articles"

    func fetch() {
        guard let url = URL(string: endpoint) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SpaceNewsResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.articles = $0 }
            .store(in: &bag)
    }
}
