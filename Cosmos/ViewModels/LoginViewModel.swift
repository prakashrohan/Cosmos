//
//  LoginViewModel.swift
//  Cosmos
//
//  Created by Rohan Prakash on 19/07/25.
//


// LoginViewModel.swift

import Foundation
import SwiftUI
import FirebaseAuth
import Firebase
import GoogleSignIn

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showSignUp = false
    @Published var opacity = 0.0
    @Published var navigateToHome = false

    var appState: AppState?  // 👈 Injected from LoginView

    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password."
            return
        }

        isLoading = true
        errorMessage = nil

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    print("User logged in successfully!")
                    self.appState?.isTabBarHidden = false // ✅ Show tab bar
                    self.navigateToHome = true
                }
            }
        }
    }

    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.errorMessage = "Missing Google Client ID."
            return
        }

        let config = GIDConfiguration(clientID: clientID)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            self.errorMessage = "Unable to access root ViewController."
            return
        }

        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { signResult, error in
            if let error = error {
                print("❌ Google Sign-In error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                return
            }

            guard let user = signResult?.user,
                  let idToken = user.idToken?.tokenString else {
                self.errorMessage = "Failed to get Google ID token."
                return
            }

            let accessToken = user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: accessToken)

            Auth.auth().signIn(with: credential) { result, err in
                DispatchQueue.main.async {
                    if let err = err {
                        self.errorMessage = err.localizedDescription
                    } else {
                        print("✅ Google SignIn -> Firebase success!")
                        self.appState?.isTabBarHidden = false // ✅ Show tab bar
                        self.navigateToHome = true
                    }
                }
            }
        }
    }
}

