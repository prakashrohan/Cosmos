import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .navigationBarHidden(true)
        }
    }
}

struct HomeView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.05, blue: 0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: Title Block
                VStack(spacing: 8) {
                    Text("Cosmos Explorer")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: Color.blue.opacity(0.7), radius: 10, x: 0, y: 5)

                    Text("Unlock the secrets of the night sky")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)

                // MARK: Scroll Content
                Spacer(minLength: 20)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 40) {
                        // Section 1: Featured Today
                        SectionHeader(title: "Featured Today")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                homeCards(title: "Today's APOD", subtitle: "Stunning cosmic image", icon: "sparkles", width: 300, height: 200, imageName: "constellation-1")
                                homeCards(title: "AR Spotlight", subtitle: "Place planets in your room", icon: "arkit", width: 300, height: 200, imageName: "home-img-1")
                            }
                            .padding(.horizontal, 20)
                        }

                        // Section 2: Explore the Cosmos
                        SectionHeader(title: "Explore the Cosmos")
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 20),
                                GridItem(.flexible(), spacing: 20)
                            ],
                            spacing: 20
                        ) {
                            homeCards(title: "Date Range Gallery", subtitle: "Browse by date", icon: "calendar", width: 180, height: 220, imageName: nil)
                            
                            homeCards(title: "Constellation Predictor", subtitle: "AI reveals star patterns", icon: "cpu", width: 180, height: 220, imageName: nil)
                            
                            homeCards(title: "Deep Space Gallery", subtitle: "Explore nebulae & galaxies", icon: "globe", width: 180, height: 220, imageName: nil)
                            
                            homeCards(title: "Favorites", subtitle: "Your saved shots", icon: "star.fill", width: 180, height: 220, imageName: nil)
                        }
                        .padding(.horizontal, 20)

                        // Section 3: Discover More
                        SectionHeader(title: "Discover More")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 30) {
                                homeCards(title: "Night Sky Tips", subtitle: "Improve your observation", icon: "lightbulb", width: 300, height: 200, imageName: "home-img-2")
                                
                                homeCards(title: "Mythology & Stars", subtitle: "Learn the legends", icon: "book", width: 300, height: 200, imageName: "home-img-3")
                                
                                homeCards(title: "Upcoming Events", subtitle: "Track meteor showers", icon: "calendar.badge.star", width: 300, height: 200, imageName: "home-img-4")
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.bottom, 100) // space for TabBar overlay
                }
            }
            // MARK: TabBar Overlay
//            .overlay(
//                VStack {
//                    Spacer()
//                    TabBar()
//                        .padding(.bottom, -20)
//                }
//            )
        }
    }
}

// MARK: – Section Header
struct SectionHeader: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}





// MARK: – Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
