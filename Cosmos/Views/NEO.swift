//
//  NEO.swift
//  Cosmos
//
//  Created by Rohan Prakash on 24/01/25.
//

import SwiftUI

struct NearEarthObject: Codable, Identifiable {
    let id: String
    let name: String
    let nasa_jpl_url: String
    let close_approach_data: [CloseApproachData]
}

struct CloseApproachData: Codable {
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
        NavigationView {
            List(viewModel.neos) { neo in
                VStack(alignment: .leading, spacing: 10) {
                    Text(neo.name)
                        .font(.headline)
                    
                    if let approachData = neo.close_approach_data.first {
                        Text("Close Approach Date: \(approachData.close_approach_date_full)")
                            .font(.subheadline)
                    }
                    
                    Link("View More", destination: URL(string: neo.nasa_jpl_url)!)
                        .foregroundColor(.blue)
                }
                .padding()
            }
            .navigationTitle("Near-Earth Objects")
            .onAppear {
                viewModel.fetchNEOData()
            }
        }
    }
}

struct NEOView_Previews: PreviewProvider {
    static var previews: some View {
        NEOView()
    }
}

