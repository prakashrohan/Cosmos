//
//  MoonPhaseView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 17/07/25.
//


import SwiftUI
import CoreLocation

struct MoonPhaseView: View {
    @StateObject private var viewModel = MoonPhaseViewModel()
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.05, blue: 0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Moon Phase")
                    .font(.largeTitle.bold())
                    .foregroundStyle(
                        LinearGradient(colors: [Color.purple, Color.blue],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .shadow(color: Color.blue.opacity(0.7), radius: 10)

                if viewModel.isLoading {
                    ProgressView("Loading Moon Phase...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else if let imageUrl = viewModel.moonImageURL,
                          let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(16)
                            .shadow(color: .blue.opacity(0.4), radius: 10)
                            .padding()
                    } placeholder: {
                        ProgressView()
                    }

                    Text("Based on your current location")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.6))
                } else {
                    Text("Waiting for location...")
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding()
        }
        .onAppear {
            if let location = locationManager.currentLocation {
                viewModel.fetchMoonPhase(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    date: DateFormatter.api.string(from: Date())
                )
            }
        }
        .onChange(of: locationManager.currentLocation) { location in
            if let location {
                viewModel.fetchMoonPhase(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    date: DateFormatter.api.string(from: Date())
                )
            }
        }
    }
}


extension DateFormatter {
    static var api: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
struct MoonPhaseView_Previews: PreviewProvider {
    static var previews: some View {
        MoonPhaseView()
            .environmentObject(LocationManager())
            .preferredColorScheme(.dark)
    }
}
