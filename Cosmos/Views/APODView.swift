//
//  APODView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 15/12/24.
//


import SwiftUI
import Combine

struct APODView: View {
    @State private var apod: APOD?
    @State private var cancellable: AnyCancellable?

    var body: some View {
        VStack {
            if let apod = apod {
                if apod.media_type == "image" {
                    AsyncImage(url: URL(string: apod.url ?? "title")) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                } else if apod.media_type == "video" {
                    VideoPlayerView(urlString: apod.url ?? "title")
                }

                Text(apod.title ?? "title").font(.title).padding()
                Text(apod.explanation ?? "title").padding()
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            cancellable = NASAService.shared.fetchAPOD()
                .sink(receiveCompletion: { print($0) },
                      receiveValue: { self.apod = $0 })
        }
    }
}

// Placeholder for video player
import AVKit
import Combine

struct VideoPlayerView: View {
    let urlString: String

    var body: some View {
        if let url = URL(string: urlString) {
            VideoPlayer(player: AVPlayer(url: url))
                .frame(height: 300)
        } else {
            Text("Unable to load video.")
        }
    }
}
