//
//  MainTabView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 16/07/25.
//


import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .swap  // ⬅️ default tab

    var body: some View {
        ZStack {
            // Tab content
            Group {
                switch selectedTab {
                case .home:
                    Text("Swap Screen") // or SwapView()
                case .markets:
                    Text("Markets View")
                case .swap:
                    ContentView()  // ⬅️ This is your homepage!
                case .wallet:
                    Text("Wallet View")
                case .profile:
                    Text("Profile View")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom TabBar overlayed on bottom
            VStack {
                Spacer()
                AnimatedNeonTabBar(selected: $selectedTab)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color.black)
    }
}
