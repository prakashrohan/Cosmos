// LoginView.swift

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel: LoginViewModel

    init() {
        _viewModel = StateObject(wrappedValue: LoginViewModel())
    }

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.3)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            // Navigate to Home if Logged In
            if viewModel.navigateToHome {
                MainTabView()
                    .environmentObject(appState) // ✅ carry over tab state
            } else {
                VStack {
                    Text("Welcome Back")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .blue.opacity(0.6), radius: 10, x: 0, y: 4)
                        .padding(.bottom, 30)

                    VStack(spacing: 16) {
                        CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $viewModel.email)
                        CustomTextField(icon: "lock.fill", placeholder: "Password", text: $viewModel.password, isSecure: true)

                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.top, 5)
                        }

                        Button(action: viewModel.login) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(height: 50)
                                    .shadow(color: .blue.opacity(0.6), radius: 10, x: 0, y: 4)

                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Login")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .disabled(viewModel.isLoading)
                        .padding(.top, 10)
                        .scaleEffect(viewModel.isLoading ? 0.95 : 1.0)
                        .animation(.spring(), value: viewModel.isLoading)

                        Button(action: viewModel.signInWithGoogle) {
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

                        Button(action: { viewModel.showSignUp.toggle() }) {
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
                .opacity(viewModel.opacity)
                .onAppear {
                    viewModel.appState = appState
                    withAnimation(.easeInOut(duration: 1.2)) {
                        viewModel.opacity = 1.0
                    }
                }
                .fullScreenCover(isPresented: $viewModel.showSignUp) {
                    SignUpView()
                        .environmentObject(appState)
                }
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
