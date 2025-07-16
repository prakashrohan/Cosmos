//
//  FunkyCard.swift
//  Cosmos
//
//  Created by Rohan Prakash on 16/07/25.
//
import SwiftUI
import Foundation

struct homeCards: View {
    let title: String
    let subtitle: String
    let icon: String
    let width: CGFloat?
    let height: CGFloat
    let imageName: String?
    
    var body: some View {
        ZStack {
            // Optional Background Image
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0.2)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(20)
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.08, green: 0.08, blue: 0.12))
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                        Image(systemName: icon)
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .medium))
                    }
                    Spacer()
                }
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding()
        }
        .frame(width: width, height: height)
    }
}
