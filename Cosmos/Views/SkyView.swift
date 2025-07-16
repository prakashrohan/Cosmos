//
//  SkyView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 26/01/25.
//

import SwiftUI
import CoreLocation
import CoreMotion

struct SkyView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var motionManager = MotionManager()
    @State private var constellationName = "Unknown"
    @State private var starChartUrl: String? = nil
    @State private var isLoading = true

    private let skyMapService = SkyMapService() // Instance of the service

    var body: some View {
        VStack {
            Text("Point your phone at the sky!")
                .font(.title)
                .padding()

            Text("Constellation: \(constellationName)")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue.opacity(0.7))
                .cornerRadius(10)
                .padding()

            if let starChartUrl = starChartUrl {
                AsyncImage(url: URL(string: starChartUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView("Loading star chart...")
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .cornerRadius(10)
                            .padding()
                    case .failure:
                        Text("Failed to load star chart.")
                            .foregroundColor(.red)
                    @unknown default:
                        Text("Unknown error occurred.")
                    }
                }
            } else if isLoading {
                ProgressView("Fetching constellation and star chart...")
                    .padding()
            } else {
                Text("No star chart available.")
                    .foregroundColor(.gray)
                    .padding()
            }

            Spacer()
        }
        .onAppear {
            motionManager.startUpdates()
        }
        .onDisappear {
            motionManager.stopUpdates()
        }
        .onChange(of: motionManager.attitude) { attitude in
            if let location = locationManager.currentLocation, let attitude = attitude {
                fetchConstellation(location: location, attitude: attitude)
            }
        }
    }

    // Fetch constellation data using the SkyMapService
    func fetchConstellation(location: CLLocation, attitude: CMAttitude) {
        let (azimuth, altitude) = calculateAzimuthAndAltitude(attitude: attitude)
        let date = getCurrentDate()

        // Use dynamic constellation calculation or an external API mapping
        let constellationID = calculateConstellationID(azimuth: azimuth, altitude: altitude)

        skyMapService.generateConstellationStarChart(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            date: date,
            constellationID: constellationID
        ) { imageUrl in
            DispatchQueue.main.async {
                if let imageUrl = imageUrl {
                    self.starChartUrl = imageUrl
                } else {
                    self.starChartUrl = nil
                }
                self.constellationName = constellationIDToName(constellationID: constellationID)
                self.isLoading = false
            }
        }
    }

    
    func calculateAzimuthAndAltitude(attitude: CMAttitude) -> (azimuth: Double, altitude: Double) {
        let azimuth = attitude.yaw * (180 / .pi) // Convert radians to degrees
        let altitude = attitude.pitch * (180 / .pi)
        return (azimuth, altitude)
    }

  
    func calculateConstellationID(azimuth: Double, altitude: Double) -> String {
        // Replace this logic with actual dynamic constellation mapping logic
        if azimuth > 0 && azimuth < 180 {
            return "ori" // Orion
        } else if azimuth >= 180 && azimuth < 360 {
            return "uma" // Ursa Major
        } else {
            return "cma" // Canis Major
        }
    }

   
    func constellationIDToName(constellationID: String) -> String {
        switch constellationID {
        case "ori":
            return "Orion"
        case "uma":
            return "Ursa Major"
        case "cma":
            return "Canis Major"
        default:
            return "Unknown"
        }
    }

   
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
}

#Preview {
    SkyView()
}
