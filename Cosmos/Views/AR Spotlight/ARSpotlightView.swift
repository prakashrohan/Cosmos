

import SwiftUI
import FirebaseFirestore


struct ARSpotlightView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedCategory: ARCategory = .planets
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack{
            ZStack(alignment: .topLeading) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.05, blue: 0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top Image
                    Image("home-img-1")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                        .padding(.bottom,-50)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.7), .clear]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )


                    // Category Tabs
                    
                    HStack {
                        Text("AR Spotlight")
                            .font(.title2.bold())
                            .foregroundColor(.white)

                        Spacer()

                     
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    Spacer(minLength: 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(ARCategory.allCases, id: \.self) { category in
                                CategoryButton(category: category, isSelected: selectedCategory == category)
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            selectedCategory = category
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                        //.padding(.top, 10)
                    }

                  
                    
                    Spacer(minLength: 20)

                    // Item Grid
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(items(for: selectedCategory)) { item in
                                ModelCard(model: item)
                            }
                        }
                        .padding()
                    }
                }

                // Back Button
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.leading, 16)
                .padding(.top, -20) // Enough space for notch/safe area
            }
        }.onAppear { appState.isTabBarHidden = true }
        .onDisappear { appState.isTabBarHidden = false }
        .navigationBarBackButtonHidden(true)
        }
       
}


// MARK: - Category Enum
enum ARCategory: String, CaseIterable {
    case planets, moons, iss, satellites

    var icon: String {
        switch self {
        case .planets: return "globe"
        case .moons: return "moon"
        case .iss: return "airplane"
        case .satellites: return "antenna.radiowaves.left.and.right"
        }
    }

    var label: String {
        self.rawValue.capitalized
    }
}

// MARK: - Category Button
struct CategoryButton: View {
    let category: ARCategory
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: category.icon)
                .font(.title2)
                .frame(width: 60, height: 60)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .gray)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

            Text(category.label)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Model Card
struct ARModel: Identifiable {
    var id: String { modelFile }  // Use modelFile as stable ID
    let name: String
    let imageName: String
    let modelFile: String
}



func items(for category: ARCategory) -> [ARModel] {
    switch category {
    case .planets:
        return [
            ARModel(name: "Earth", imageName: "earth", modelFile: "Earth_1_12756"),
            ARModel(name: "Mars", imageName: "mars", modelFile: "24881_Mars_1_6792")
        ]
    case .moons:
        return [
            ARModel(name: "Luna", imageName: "luna", modelFile: "moon"),
            ARModel(name: "Eris", imageName: "eris", modelFile: "Eris_1_2326")
            
        ]
    case .iss:
        return [
            ARModel(name: "ISS", imageName: "ISS", modelFile: "ISS_stationary")
        ]
    case .satellites:
        return [
            ARModel(name: "Hubble", imageName: "hubble", modelFile: "Hubble"),
            ARModel(name: "Clipper", imageName: "clipper", modelFile: "gclipper_maspex"),
            ARModel(name: "Ingenuity", imageName: "ingenuity", modelFile: "25043_Ingenuity_v3"),
            ARModel(name: "Perseverance", imageName: "perseverance", modelFile: "25042_Perseverance"),
            ARModel(name: "Curiosity", imageName: "curiosity", modelFile: "24584_Curiosity_static")
        ]
    }
}






// MARK: - Preview
struct ARSpotlightView_Previews: PreviewProvider {
    static var previews: some View {
        ARSpotlightView()
            .environmentObject(AppState())
            .preferredColorScheme(.dark)
    }
}
