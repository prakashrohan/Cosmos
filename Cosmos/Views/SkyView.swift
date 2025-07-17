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
    @Environment(\.dismiss) var dismiss
    @StateObject private var locationManager = LocationManager()
    @StateObject private var motionManager = MotionManager()
    @State private var constellationName = "..."
    @State private var starChartUrl: String? = nil
    @State private var lastUpdateAzimuth: Double = 0
    @State private var isLoading = true
    @EnvironmentObject var appState: AppState
    private let skyMapService = SkyMapService()
    private let updateThreshold: Double = 10 // degrees

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.05, blue: 0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // 🌌 Top Image Banner
                Image("home-img-2")
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

                // 🔭 Title
                Text("Sky Scanner")
                    .font(.largeTitle.bold())
                    .foregroundStyle(LinearGradient(colors: [Color.purple, Color.blue], startPoint: .leading, endPoint: .trailing))
                    .shadow(color: .blue.opacity(0.8), radius: 10)
                    .padding(.top, -200)
                    .padding(.bottom, 20)
                    
                // ✨ Constellation Display
                Text("🔭 Constellation: \(constellationName)")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Capsule())
                    Spacer(minLength: 16)

                // 🗺 Star Chart Image
                if let url = starChartUrl {
                    AsyncImage(url: URL(string: url)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView("Loading star chart...")
                                .padding()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(16)
                                .shadow(radius: 10)
                                .padding(.horizontal)
                        case .failure:
                            Text("Failed to load star chart")
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else if isLoading {
                    ProgressView("Scanning sky...")
                        .padding()
                }

                Spacer()
            }

            // 🔙 Back Button
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
            .padding(.top, -8)
        }
        .onAppear {
            motionManager.startUpdates();appState.isTabBarHidden = true
        }
        .onDisappear {
            motionManager.stopUpdates();appState.isTabBarHidden = false
        }
        .onChange(of: motionManager.attitude) { attitude in
            guard let attitude = attitude, let location = locationManager.currentLocation else { return }

            let (azimuth, altitude) = calculateAzimuthAndAltitude(attitude: attitude)

            if abs(azimuth - lastUpdateAzimuth) > updateThreshold {
                lastUpdateAzimuth = azimuth
                fetchStarChart(for: location, azimuth: azimuth, altitude: altitude)
            }
               // .onAppear { appState.isTabBarHidden = true }
               // .onDisappear { appState.isTabBarHidden = false }
        } .navigationBarBackButtonHidden(true)
    }

    // MARK: - Logic
    func fetchStarChart(for location: CLLocation, azimuth: Double, altitude: Double) {
        let date = getCurrentDate()
        let constellationID = calculateConstellationID(azimuth: azimuth, altitude: altitude)

        skyMapService.generateConstellationStarChart(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            date: date,
            constellationID: constellationID
        ) { imageUrl in
            DispatchQueue.main.async {
                self.starChartUrl = imageUrl
                self.constellationName = constellationIDToName(constellationID: constellationID)
                self.isLoading = false
            }
        }
    }

    func calculateAzimuthAndAltitude(attitude: CMAttitude) -> (azimuth: Double, altitude: Double) {
        let azimuth = attitude.yaw * (180 / .pi)
        let altitude = attitude.pitch * (180 / .pi)
        return (azimuth, altitude)
    }

    func calculateConstellationID(azimuth: Double, altitude: Double) -> String {
        if altitude > 45 {
            return "ori"
        } else if azimuth > 90 && azimuth < 270 {
            return "uma"
        } else {
            return "cma"
        }
    }

    func constellationIDToName(constellationID: String) -> String {
        switch constellationID {
        case "ori": return "Orion"
        case "uma": return "Ursa Major"
        case "cma": return "Canis Major"
        default: return "Unknown"
        }
    }

    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}


#Preview {
    SkyView()
        .environmentObject(AppState())
}
