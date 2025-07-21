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

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private static let cache = NSCache<NSString, UIImage>()

    private var url: URL?
    private var cancellable: AnyCancellable?

    init(url: URL?) {
        self.url = url
        load()
    }

    func load() {
        guard let url else { return }

        let cacheKey = NSString(string: url.absoluteString)
        if let cachedImage = Self.cache.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadedImage in
                guard let self = self, let image = downloadedImage else { return }
                Self.cache.setObject(image, forKey: cacheKey)
                self.image = image
            }
    }

    deinit {
        cancellable?.cancel()
    }
}

struct CachedAsyncImage: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Image

    init(url: URL?, placeholder: Image = Image("news-placeholder")) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }

    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            placeholder
                .resizable()
                .overlay(Color.black.opacity(0.3))
        }
    }
}

