//
//  APODRangeView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 15/12/24.
//


import SwiftUI
import Combine

struct APODRangeView: View {
    @State private var apods: [APOD] = []
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    @State private var endDate = Date()
    @State private var cancellable: AnyCancellable?
    
    // MARK: - UI Control States
    @State private var showDatePickers = false        // Toggles the date picker card
    @State private var isFetching = false             // Controls the fetching animation

    var body: some View {
        ZStack {
            // 🌌 Starfield + Gradient Background
            CosmicBackgroundView()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // 🌠 Title
                Text("Explore APODs by Date")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .shadow(color: .blue.opacity(0.6), radius: 10, x: 0, y: 4)
                    .padding(.top, 20)

                // 💫 Toggle Button for Date Range Card
                Button(action: {
                    withAnimation(.spring()) {
                        showDatePickers.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: showDatePickers ? "chevron.down.circle.fill" : "chevron.right.circle.fill")
                        Text(showDatePickers ? "Hide Date Range" : "Select Date Range")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(radius: 8)
                }
                
                // 🗓 Expandable Date Picker Card
                if showDatePickers {
                    VStack(spacing: 10) {
                        // Start Date
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .padding()
                            .background(BlurView(style: .systemUltraThinMaterialDark))
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        
                        // End Date
                        DatePicker("End Date", selection: $endDate, in: startDate...Date(), displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .padding()
                            .background(BlurView(style: .systemUltraThinMaterialDark))
                            .cornerRadius(12)
                            .shadow(radius: 5)

                        // 🔎 Fetch Button
                        Button(action: fetchAPODsForRange) {
                            if isFetching {
                                HStack {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    Text("Fetching...")
                                }
                            } else {
                                Text("Fetch Images")
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green.opacity(0.9), Color.blue.opacity(0.9)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(radius: 8)
                        .padding(.horizontal, 40)
                        .animation(.spring(), value: isFetching)
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.horizontal, 20)
                }
                
                // 🖼 APOD Results
                if apods.isEmpty {
                    if !isFetching {
                        Text("No APODs found.\nSelect a date range to begin.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.top, 20)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(apods) { apod in
                                APODCard(apod: apod)
                                    .padding(.horizontal)
                                    .transition(.slide.combined(with: .opacity))
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.bottom, 10)
        }
        .navigationTitle("APOD Explorer")
    }
    
    // MARK: - Fetch APODs Based on Date Range
    private func fetchAPODsForRange() {
        isFetching = true
        apods.removeAll()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let formattedStartDate = formatter.string(from: startDate)
        let formattedEndDate = formatter.string(from: endDate)

        cancellable = NASAService.shared.fetchAPODRange(startDate: formattedStartDate, endDate: formattedEndDate)
            .sink(receiveCompletion: { completion in
                print(completion)
                DispatchQueue.main.async {
                    self.isFetching = false
                }
            }, receiveValue: { fetchedAPODs in
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        self.apods = fetchedAPODs
                    }
                    self.isFetching = false
                }
            })
    }
}

// MARK: - 📷 APOD Card
struct APODCard: View {
    let apod: APOD

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(apod.title ?? "Untitled")
                .font(.headline)
                .foregroundColor(.white)
                .shadow(radius: 5)

            // Image or Placeholder
            if let urlString = apod.url, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .cornerRadius(10)
                .shadow(radius: 5)
            } else {
                Text("No valid image URL")
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

// MARK: - 🌌 Cosmic Background (Gradient + Starfield)
struct CosmicBackgroundView: View {
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea(edges: .bottom)
            // Base Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Starfield
            StarfieldView()
        }
    }
}

// MARK: - 🌠 Starfield Implementation

struct APODRangeView_Previews: PreviewProvider {
    static var previews: some View {
        APODRangeView()
    }
}
