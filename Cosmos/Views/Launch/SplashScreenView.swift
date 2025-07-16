import SwiftUI
import FirebaseAuth

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var navigateToLogin = false
    @State private var navigateToHome = false
    @State private var opacity = 0.0 // Initially hidden for fade-in effect

    var body: some View {
        ZStack {
            if navigateToHome {
                MainTabView() // 🚀 Redirect to Home if Logged In
                    .transition(.opacity)
            }
//            else if navigateToLogin {
//                LoginView() // 🔑 Redirect to Login if Not Logged In
//                    .transition(.opacity)
           // }
        else  {
                ZStack {
                    // 🔵 Matching Gradient Background
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.3)]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)

                    // 🌠 Starfield Effect
                    StarfieldView()

                    VStack {
                        // 🚀 Animated Logo
                        Image(systemName: "moon.stars.fill") // Replace with your logo
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.white)
                            .shadow(color: .blue.opacity(0.8), radius: 20, x: 0, y: 10)

                        // 🌌 App Name
                        Text("COSMOS")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .blue.opacity(0.6), radius: 10, x: 0, y: 4)
                            .padding(.top, 10)

                        // ✨ Tagline
                        Text("Explore the Universe")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top, 5)
                    }
                }
                .opacity(opacity) // Handles both fade-in and fade-out
//                .onAppear {
//                    withAnimation(.easeInOut(duration: 1.2)) {
//                        self.opacity = 1.0 // 🌟 Fade-In Effect
//                    }
//                    checkSession() // 🔥 Check if user is logged in
//                }
                .onAppear {
                    // 1. Fade in the splash
                    withAnimation(.easeInOut(duration: 1.2)) {
                        self.opacity = 1.0
                    }

                    // 2. Wait, then fade out and show MainTabView
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            self.opacity = 0.0
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.navigateToHome = true
                        }
                    }
                }

            }
        }
        .animation(.easeInOut(duration: 1.0), value: isActive)
    }

    // MARK: - 🔍 Check User Session
//    private func checkSession() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//            withAnimation(.easeInOut(duration: 1.0)) {
//                self.opacity = 0.0 // 🌟 Fade-Out Effect
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                if Auth.auth().currentUser != nil {
//                    self.navigateToHome = true
//                } else {
//                    self.navigateToLogin = true
//                }
//            }
//        }
//    }
}

// MARK: - 🌠 Starfield Effect
struct StarfieldView: View {
    @State private var stars = (0..<100).map { _ in
        Star(position: CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                               y: CGFloat.random(in: 0...UIScreen.main.bounds.height)),
             size: CGFloat.random(in: 1...3))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(stars.indices, id: \.self) { index in
                    Circle()
                        .frame(width: stars[index].size, height: stars[index].size)
                        .foregroundColor(.white.opacity(0.8))
                        .position(stars[index].position)
                        .onAppear {
                            moveStar(index, in: geometry.size)
                        }
                }
            }
        }
    }
    
    private func moveStar(_ index: Int, in size: CGSize) {
        let newPosition = CGPoint(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height))
        
        withAnimation(Animation.linear(duration: Double.random(in: 3...6)).repeatForever(autoreverses: false)) {
            stars[index].position = newPosition
        }
    }
}

struct Star: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
}

// MARK: - 📸 Preview
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .preferredColorScheme(.dark)
    }
}
