import SwiftUI
import FirebaseAuth

// MARK: - Splash Screen View
struct SplashScreenView: View {
    @State private var navigateToLogin = false
    @State private var navigateToHome = false
    @State private var opacity = 0.0
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            if navigateToHome {
                MainTabView()
                    .transition(.opacity)
                    .onAppear {
                        appState.isTabBarHidden = false
                    }
            } else if navigateToLogin {
                LoginView()
                    .transition(.opacity)
            } else {
                ZStack {
                    // Background Gradient
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.3)]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)

                    // Starfield Animation
                    StarfieldView()

                    VStack {
                        // App Icon
                        Image(systemName: "moon.stars.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.white)
                            .shadow(color: .blue.opacity(0.8), radius: 20, x: 0, y: 10)

                        // App Title
                        Text("COSMOS")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .blue.opacity(0.6), radius: 10, x: 0, y: 4)
                            .padding(.top, 10)

                        // Tagline
                        Text("Explore the Universe")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top, 5)
                    }
                }
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        self.opacity = 1.0
                    }
                    checkSession()
                }
            }
        }
        .animation(.easeInOut(duration: 1.0), value: navigateToLogin || navigateToHome)
    }

    // MARK: - Check User Session
    private func checkSession() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                self.opacity = 0.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if Auth.auth().currentUser != nil {
                    self.navigateToHome = true
                } else {
                    self.navigateToLogin = true
                }
            }
        }
    }
}

// MARK: - Starfield View
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
        let newPosition = CGPoint(x: CGFloat.random(in: 0...size.width),
                                  y: CGFloat.random(in: 0...size.height))

        withAnimation(Animation.linear(duration: Double.random(in: 3...6)).repeatForever(autoreverses: false)) {
            stars[index].position = newPosition
        }
    }
}


// MARK: - Preview
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .preferredColorScheme(.dark)
            .environmentObject(AppState())
        
    }
}
