//
//  StarRegisterView.swift
//  Cosmos
//
//  Created by Your Name on 19 Jul 25.
//

import SwiftUI
import WebKit

// MARK: - Web View Wrapper
struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = true
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
    
    func makeCoordinator() -> Coordinator { Coordinator(isLoading: $isLoading) }
    
    final class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var isLoading: Bool
        init(isLoading: Binding<Bool>) { _isLoading = isLoading }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            isLoading = true
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading = false
        }
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            isLoading = false
        }
    }
}

// MARK: - Main Screen
struct StarRegisterView: View {
    @State private var loading = true
    private let url = URL(string: "https://software.star-register.com")!
    
    var body: some View {
        ZStack {
            // Cosmic gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.05, blue: 0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            // Web content
            WebView(url: url, isLoading: $loading)
                .opacity(loading ? 0 : 1)                       // fade‑in
            
            // Loader overlay
            if loading {
                ProgressView("Loading Star‑Register…")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding(20)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(12)
            }
        }
        .navigationTitle("Star Register")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        StarRegisterView()
    }
    .preferredColorScheme(.dark)
}
