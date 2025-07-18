//
//  ProfileView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 16/02/25.
//


import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var userEmail: String = Auth.auth().currentUser?.email ?? "Unknown Email"
    @State private var userName: String = Auth.auth().currentUser?.displayName ?? "User"
    @State private var isLoggedOut = false

    var body: some View {
        ZStack {
            // 🔵 Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.3)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // 📷 Profile Image
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .blue.opacity(0.6), radius: 10, x: 0, y: 4)
                    .padding(.top, 40)

                // 🏷 User Name
                Text(userName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // ✉️ User Email
                Text(userEmail)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))

                Spacer()

                // 🚪 Logout Button
                Button(action: logout) {
                    Text("Logout")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 150)
                
            }
        }
        .fullScreenCover(isPresented: $isLoggedOut) {
            LoginView() // Redirects to Login Screen after logout
        }
    }

    // MARK: - 🔑 Logout Function
    private func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true
        } catch {
            print("Logout failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - 📸 Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
