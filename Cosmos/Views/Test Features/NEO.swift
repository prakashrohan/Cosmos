import SwiftUI

struct NearEarthObject: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let nasa_jpl_url: String
    let close_approach_data: [CloseApproachData]
}

struct CloseApproachData: Codable,Equatable {
    let close_approach_date_full: String
}

struct NEOResponse: Codable {
    let near_earth_objects: [String: [NearEarthObject]]
}

class NEOViewModel: ObservableObject {
    @Published var neos: [NearEarthObject] = []
    
    func fetchNEOData() {
        let urlString = "https://api.nasa.gov/neo/rest/v1/feed?start_date=2015-09-07&end_date=2015-09-08&api_key=DEMO_KEY"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error fetching data:", error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                let response = try JSONDecoder().decode(NEOResponse.self, from: data)
                let allNEOs = response.near_earth_objects.flatMap { $0.value }
                
                DispatchQueue.main.async {
                    self.neos = allNEOs
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
}

struct NEOView: View {
    @StateObject private var viewModel = NEOViewModel()
    
    var body: some View {
        ZStack {
            // 🔵 Space-Themed Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.3)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.neos) { neo in
                        NEOCard(neo: neo)
                            .transition(.slide)
                            .animation(.easeInOut(duration: 0.6), value: viewModel.neos)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Near-Earth Objects")
        .onAppear {
            viewModel.fetchNEOData()
        }
    }
}

// MARK: - 🌠 Modern NEO Card
struct NEOCard: View {
    let neo: NearEarthObject

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 🌍 NEO Name
            Text(neo.name)
                .font(.title3.bold())
                .foregroundColor(.white)
                .shadow(radius: 5)

            // 📅 Close Approach Date
            if let approachData = neo.close_approach_data.first {
                Text("🗓 Close Approach: \(approachData.close_approach_date_full)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }

            // 🔗 NASA Link
            Link(destination: URL(string: neo.nasa_jpl_url)!) {
                HStack {
                    Image(systemName: "link")
                    Text("View More on NASA")
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)]),
                                           startPoint: .leading, endPoint: .trailing))
                .cornerRadius(12)
                .shadow(radius: 8)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}



// MARK: - 📸 Preview
struct NEOView_Previews: PreviewProvider {
    static var previews: some View {
        NEOView()
    }
}
