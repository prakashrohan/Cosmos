//
//  NeonBackground.swift
//  Cosmos
//
//  Created by Rohan Prakash on 11/07/25.
//

import Foundation

import SwiftUI
import UIKit

struct NeonBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.black, Color.blue.opacity(0.2)], startPoint: .top, endPoint: .bottom)
            StarfieldView()
        }
        .ignoresSafeArea()
    }
}



struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
