//
//  APODCard.swift
//  Cosmos
//
//  Created by Rohan Prakash on 11/07/25.
//

import SwiftUI

struct APODCard: View {
    let apod: APOD
    let animation: Namespace.ID

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(apod.title ?? "Untitled")
                .font(.headline)
                .foregroundColor(.white)

            if let url = URL(string: apod.url ?? "") {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .matchedGeometryEffect(id: apod.id, in: animation)
                } placeholder: {
                    ProgressView()
                }
                .cornerRadius(12)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 8)
    }
}
