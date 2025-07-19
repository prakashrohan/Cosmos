//
//  mythology.swift
//  Cosmos
//
//  Created by Rohan Prakash on 19/07/25.
//

//
//  meteorShower.swift
//  Cosmos
//
//  Created by Rohan Prakash on 19/07/25.
//

import SwiftUI

struct mythologyView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
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
                Image("home-img-3")
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
                Text("Mythology")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .shadow(color: .blue.opacity(0.8), radius: 10)
                    .padding(.top, -200)
                    .padding(.bottom, 20)
                
                
                
                
                Spacer()
            }
            
            
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
        
        .onAppear { appState.isTabBarHidden = true }
            .onDisappear { appState.isTabBarHidden = false }
            .navigationBarBackButtonHidden(true)
    }
   
    }
#Preview {
    mythologyView()
        .environmentObject(AppState())
    
}

