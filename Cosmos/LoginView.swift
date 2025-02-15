//
//  LoginView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 16/02/25.
//


import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showSignUp = false  // To navigate to Sign-Up
    
    var body: some View {
        ZStack {
            // 🔵 Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.3)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                // 🏷 Title
                Text("Welcome Back")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .blue.opacity(0.6), radius: 10, x: 0, y: 4)
                    .padding(.bottom, 30)

                // 🔳 Glassmorphic Container
                VStack(spacing: 16) {
                    CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                    CustomTextField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 5)
                    }

                    // 🚀 Login Button
                    Button(action: login) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)]),
                                                     startPoint: .leading, endPoint: .trailing))
                                .frame(height: 50)
                                .shadow(color: .blue.opacity(0.6), radius: 10, x: 0, y: 4)

                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Login")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                    .disabled(isLoading)
                    .scaleEffect(isLoading ? 0.95 : 1.0)
                    .animation(.spring(), value: isLoading)
                    
                    // 🔗 Sign-Up Navigation Link
                    Button(action: {
                        showSignUp.toggle()
                    }) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.blue)
                            .font(.system(size: 16, weight: .bold))
                            .underline()
                    }
                    .padding(.top, 10)
                }
                .padding()
                .background(BlurView(style: .systemUltraThinMaterialDark))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 4)
                .padding(.horizontal, 30)
            }
            .fullScreenCover(isPresented: $showSignUp) {
                SignUpView()  // Navigate to Sign-Up page
            }
        }
    }

    // 🚀 Firebase Login Function
    private func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password."
            return
        }

        isLoading = true
        errorMessage = nil

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                print("User logged in successfully!")
                // Navigate to home screen here
            }
        }
    }
}

// MARK: - 🎭 Blur Effect for Glassmorphism


// MARK: - 📸 Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
