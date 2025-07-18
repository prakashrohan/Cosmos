//
//  MainTabView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 16/07/25.
//


import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .swap
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            // Main Tab Content
            Group {
                switch selectedTab {
                case .home:
                    NASA3DModelView()
                case .markets:
                    Text("Markets View")
                case .swap:
                    ContentView()
                case .wallet:
                    Text("Wallet View")
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Tab Bar with SMOOTH, SLOW POP-UP
            if !appState.isTabBarHidden {
                VStack {
                    Spacer()
                    AnimatedNeonTabBar(selected: $selectedTab)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .move(edge: .bottom).combined(with: .opacity)
                            )
                        )
                        .padding(.bottom, 10)
                }
                .animation(.easeInOut(duration: 0.55), value: appState.isTabBarHidden)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color.black)
    }
}
