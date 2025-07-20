//
//  FavoritesView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 20/07/25.
//


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct FavoritesView: View {
    @AppStorage("userID") var userID: String = ""
    @State private var favorites: [ARModel] = []
    @EnvironmentObject var appState: AppState
    

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.05, blue: 0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
                
                if favorites.isEmpty {
                    Text("No Favorites Yet")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.title2)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(favorites) { model in
                                ModelCard(model: model)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
        }
        .onAppear {
            fetchFavorites()
            appState.isTabBarHidden = true
        }
        .onDisappear {
            appState.isTabBarHidden = false
        }
    }

    func fetchFavorites() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("⚠️ No user ID found. User might not be logged in.")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userID).collection("favorites").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching favorites: \(error.localizedDescription)")
                return
            }
            
            if let docs = snapshot?.documents {
                self.favorites = docs.compactMap { doc -> ARModel? in
                    let data = doc.data()
                    return ARModel(
                        name: data["name"] as? String ?? "",
                        imageName: data["imageName"] as? String ?? "",
                        modelFile: data["modelFile"] as? String ?? ""
                    )
                }
            }
        }
    }

}
