//
//  homeView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 16/01/25.
//
import SwiftUI
import SplineRuntime

// Function to return the Spline background view

let url = URL(string: "https://build.spline.design/LIPq-9qoiZBjMK8bHPSJ/scene.splineswift")!

   
    


struct homeView: View {
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    let items: [(String, String, Bool, AnyView)] = [
        ("house.fill", "Home", true, AnyView(ContentView())),
        ("star.fill", "Favorites", true, AnyView(APODView())),
        ("gear", "Settings", true, AnyView(APODView())),
        ("bell.fill", "Notifications", true, AnyView(APODView())),
        ("person.fill", "Profile", true, AnyView(APODView())),
        ("map.fill", "Explore", true, AnyView(APODView()))
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background using the function
                spline_purpleplanet()
                
                // Content
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items, id: \.0) { item in
                        NavigationLink(destination: item.3) {
                            CellView(iconName: item.0, title: item.1, isSelected: item.2)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
    func spline_purpleplanet() -> some View {
        SplineView(sceneFileURL: url )
            .ignoresSafeArea(.all)
            .frame( height: .infinity)
    }
}

#Preview {
    homeView()
}


