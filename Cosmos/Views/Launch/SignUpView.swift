import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // 🔵 Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.3)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                //  Title
                Text("Create Account")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .blue.opacity(0.6), radius: 10, x: 0, y: 4)
                    .padding(.bottom, 30)

                
                VStack(spacing: 16) {
                    CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                    CustomTextField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)
                    CustomTextField(icon: "lock.shield.fill", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 5)
                    }

                    
                    Button(action: signUp) {
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
                                    Text("Sign Up")
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
                }
                .padding()
                .background(BlurView(style: .systemUltraThinMaterialDark))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 4)
                .padding(.horizontal, 30)
                
                Button(action: {
                             dismiss()
                         }) {
                             Text("Back to Login")
                                 .font(.system(size: 16, weight: .semibold))
                                 .foregroundColor(.blue)
                                 .padding(.top, 20)
                                 .underline()
                         }
            }
        }
    }

    //  Firebase Sign-Up Function
    private func signUp() {
        guard !email.isEmpty, !password.isEmpty, password == confirmPassword else {
            errorMessage = "Please fill in all fields correctly."
            return
        }

        isLoading = true
        errorMessage = nil

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                print("User created successfully!")
            }
        }
    }
}

// MARK: -  Custom TextField
struct CustomTextField: View {
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

// MARK: - 🎭 Blur Effect for Glassmorphism
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// MARK: -  Preview
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
