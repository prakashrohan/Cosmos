//
//  NeonCard.swift
//  Cosmos
//
//  Created by Rohan Prakash on 11/07/25.
//

import Foundation
import SwiftUI
struct NeonCard<Content: View>: View {
    let content: () -> Content

    var body: some View {
        VStack {
            content()
        }
        .padding()
        .background(.ultraThinMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(LinearGradient(colors: [.cyan, .purple], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
        )
        .cornerRadius(20)
        .shadow(color: .purple.opacity(0.4), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}
