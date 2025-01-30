//
//  ARPlacementView..swift
//  Cosmos
//
//  Created by Rohan Prakash on 26/01/25.
//

import SwiftUI

struct ARPlacementView: View {
    let usdzFileName: String
    @State private var isPlaced = false

    var body: some View {
        ZStack {
            // Embed ARViewContainer
            ARViewContainer(usdzFileName: usdzFileName)
                .edgesIgnoringSafeArea(.all)

            if !isPlaced {
                VStack {
                    Spacer()

                    // Place Here Button
                    Button(action: {
                        isPlaced = true
                    }) {
                        Text("Place Here")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
