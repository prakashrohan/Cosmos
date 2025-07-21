//
//  SpaceNewsResponse.swift
//  Cosmos
//
//  Created by Rohan Prakash on 19/07/25.
//




import SwiftUI
import Combine
import SafariServices


struct SpaceNewsView: View {
    @StateObject private var service = SpaceNewsService()
    @State private var selectedURL: URL?
    

    var body: some View {
        ZStack {
            // Cosmic gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.05, blue: 0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            if service.articles.isEmpty {
                ProgressView("Loading Space News…")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                ScrollView {
                    LazyVStack(spacing: 24) {
                        ForEach(service.articles) { article in
                            ArticleCard(article: article)
                                .onTapGesture {
                                    if let link = URL(string: article.url) {
                                        selectedURL = link
                                    }
                                }
                        }
                    }
                    .padding(.top, 12)
                }
            }
        }
        .sheet(item: $selectedURL) { url in
            SafariView(url: url)       // in‑app Safari
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear { service.fetch() }
    }
}

struct ArticleCard: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header image
            CachedAsyncImage(url: URL(string: article.image_url ?? ""))
                .scaledToFill()
                .frame(height: 180)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, Color.black.opacity(0.75)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(16, corners: [.topLeft, .topRight])

            .frame(height: 180)
            .clipped()
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, Color.black.opacity(0.75)]),
                    startPoint: .center,
                    endPoint: .bottom
                )
            )
            .cornerRadius(16, corners: [.topLeft, .topRight])

            // Text block
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                    .foregroundColor(.white)

                HStack(spacing: 4) {
                    Text(article.news_site)
                    Text("·")
                    Text(article.published_at.prefix(10)) // yyyy‑MM‑dd
                }
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))

                Text(article.summary)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(3)
            }
            .padding(16)
        }
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}


// URL identifiable for sheet(item:)
extension URL: Identifiable {
    public var id: String { absoluteString }
}

// Rounded‑corner helper for top‑only rounding
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let bezier = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        return Path(bezier.cgPath)
    }
}
#Preview {
    SpaceNewsView()
        .preferredColorScheme(.dark)
}
