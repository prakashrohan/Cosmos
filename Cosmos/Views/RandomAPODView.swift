//
//  RandomAPODView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 15/12/24.
//


import SwiftUI
import Combine

struct RandomAPODView: View {
    @State private var apods: [APOD] = []
    @State private var cancellable: AnyCancellable?

    var body: some View {
        VStack {
            Button("Fetch Random Images") {
                cancellable = NASAService.shared.fetchRandomAPOD(count: 5)
                    .sink(receiveCompletion: { print($0) },
                          receiveValue: { self.apods = $0 })
            }
            .padding()

            List(apods) { apod in
                VStack(alignment: .leading) {
                    Text(apod.title ?? "title").font(.headline)
                    AsyncImage(url: URL(string: apod.url ?? "title")) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
        }
    }
}
