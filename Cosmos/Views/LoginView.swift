import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift  // If using Google's SwiftUI component
import Firebase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showSignUp = false
    @State private var opacity = 0.0  // For fade-in
    @State private var navigateToHome = false  // Navigate to ContentView if login is successful

    var body: some View {
        ZStack {
            // 🔵 Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.3)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            // If user is logged in => Navigate to ContentView
            if navigateToHome {
                ContentView()
            } else {
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
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.9),
                                                                                     Color.purple.opacity(0.9)]),
                                                         startPoint: .leading,
                                                         endPoint: .trailing))
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

                        // 🔑 Google Sign-In Button
                        Button(action: signInWithGoogle) {
                            HStack {
                                Image(systemName: "globe")
                                Text("Sign in with Google")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(10)
                            .shadow(radius: 4)
                        }
                        .padding(.top, 5)

                        // 🔗 Sign-Up Navigation Link
                        Button(action: { showSignUp.toggle() }) {
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
                .opacity(opacity) // Handles fade-in effect
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        self.opacity = 1.0  // Fade-In Effect
                    }
                }
                .fullScreenCover(isPresented: $showSignUp) {
                    SignUpView()  // Navigate to Sign-Up page
                }
            }
        }
    }

    // MARK: - 🚀 Firebase Email/Password Login
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
                self.errorMessage = error.localizedDescription
            } else {
                print("User logged in successfully!")
                navigateToHome = true
            }
        }
    }

    private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.errorMessage = "Missing Google Client ID."
            return
        }

        let config = GIDConfiguration(clientID: clientID)

        // Present from the root view controller
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

            // In the new SDK, accessToken is no longer optional
            let accessToken = user.accessToken.tokenString
            
            // Create Firebase credential
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: accessToken)

            // Sign in with Firebase
            Auth.auth().signIn(with: credential) { result, err in
                if let err = err {
                    self.errorMessage = err.localizedDescription
                } else {
                    print("✅ Google SignIn -> Firebase success!")
                    // Navigate to your ContentView or home screen
                    // e.g., self.navigateToHome = true
                }
            }
        }
    }

    }


// MARK: - 🎭 Blur Effect for Glassmorphism


// MARK: - Custom TextField
struct customTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue.opacity(0.8))
                .padding(.leading, 10)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
            } else {
                TextField(placeholder, text: $text)
                    .padding()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                                       startPoint: .leading, endPoint: .trailing), lineWidth: 1)
        )
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
        .foregroundColor(.white)
        .padding(.horizontal)
    }
}

// MARK: - 📸 Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
