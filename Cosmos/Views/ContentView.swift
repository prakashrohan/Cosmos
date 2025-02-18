//
//  ContentView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 15/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            APODView()
                .tabItem { Label("Today's APOD", systemImage: "photo") }
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "home") }

            APODRangeView()
                .tabItem { Label("Explore Range", systemImage: "calendar") }

            RandomAPODView()
                .tabItem { Label("Random APODs", systemImage: "shuffle") }
        }
    }
}


#Preview {
    ContentView()
}
