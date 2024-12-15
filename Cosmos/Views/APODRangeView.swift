//
//  APODRangeView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 15/12/24.
//


import SwiftUI
import Combine

struct APODRangeView: View {
    @State private var apods: [APOD] = []
    @State private var startDate = "2024-01-01"
    @State private var endDate = "2024-01-07"
    @State private var cancellable: AnyCancellable?

    var body: some View {
        VStack {
            TextField("Start Date (YYYY-MM-DD)", text: $startDate)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("End Date (YYYY-MM-DD)", text: $endDate)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Fetch Images") {
                cancellable = NASAService.shared.fetchAPODRange(startDate: startDate, endDate: endDate)
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
        .padding()
    }
}
