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
    @State private var isFetching = false
    @State private var showDatePickers = false
    @State private var expandedAPOD: APOD? = nil
    @Namespace private var animation
    @State private var cancellable: AnyCancellable?

    var body: some View {
        ZStack {
            NeonBackground()

            VStack(spacing: 20) {
                Text("APOD Archive")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .blue, radius: 10)

                // Date Range Picker Card
                NeonCard {
                    VStack(spacing: 15) {
                        HStack {
                            Text("📅 Date Range")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Button {
                                withAnimation { showDatePickers.toggle() }
                            } label: {
                                Image(systemName: showDatePickers ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.white)
                            }
                        }

                        if showDatePickers {
                            VStack(spacing: 10) {
                                DatePicker("From", selection: $startDate, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()

                                DatePicker("To", selection: $endDate, in: startDate...Date(), displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(.horizontal)
                }

                // APOD Cards Scroll
                ScrollView {
                    LazyVStack(spacing: 20) {
                        if apods.isEmpty && !isFetching {
                            Text("No images found.\nTry a new date range.")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white.opacity(0.6))
                                .padding()
                        } else {
                            ForEach(apods) { apod in
                                APODCard(apod: apod, animation: animation)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                            expandedAPOD = apod
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.bottom, 120)
                    .padding(.horizontal)
                }
            }

            // Floating Fetch Button
            VStack {
                Spacer()
                Button(action: fetchAPODsForRange) {
                    HStack {
                        if isFetching {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "arrow.down.circle.fill")
                            Text("Fetch APODs")
                        }
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                }
            }

            // Expanded View
            if let expanded = expandedAPOD {
                ExpandedAPODCard(apod: expanded, animation: animation, dismiss: {
                    withAnimation(.spring()) { expandedAPOD = nil }
                }, viewARAction: {
                    print("View in AR tapped for \(expanded.title ?? "")")
                })
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Fetch
    private func fetchAPODsForRange() {
        isFetching = true
        apods.removeAll()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let start = formatter.string(from: startDate)
        let end = formatter.string(from: endDate)

        cancellable = NASAService.shared.fetchAPODRange(startDate: start, endDate: end)
            .sink(receiveCompletion: { _ in
                DispatchQueue.main.async { self.isFetching = false }
            }, receiveValue: { fetched in
                DispatchQueue.main.async {
                    withAnimation { self.apods = fetched }
                    self.isFetching = false
                }
            })
    }
}

// MARK: - 🌠 Starfield Implementation

struct APODRangeView_Previews: PreviewProvider {
    static var previews: some View {
        APODRangeView()
    }
}
