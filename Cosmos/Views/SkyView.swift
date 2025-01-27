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

    /// Fetch constellation data using the SkyMapService
    func fetchConstellation(location: CLLocation, attitude: CMAttitude) {
        let (azimuth, altitude) = calculateAzimuthAndAltitude(attitude: attitude)
        
        // Call the SkyMapService
        skyMapService.fetchConstellation(location: location, azimuth: azimuth, altitude: altitude) { name in
            DispatchQueue.main.async {
                constellationName = name ?? "Unknown"
            }
        }
    }

    /// Calculate azimuth and altitude from device attitude
    func calculateAzimuthAndAltitude(attitude: CMAttitude) -> (azimuth: Double, altitude: Double) {
        let azimuth = attitude.yaw * (180 / .pi) // Convert radians to degrees
        let altitude = attitude.pitch * (180 / .pi)
        return (azimuth, altitude)
    }
}
#Preview {
    SkyView()
}
