//
//  SwiftUIView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 16/01/25.
//

import SwiftUI
import SplineRuntime

struct launchView: View {
    @State private var showContentView = false
    let sceneURL = URL(string: "https://build.spline.design/ixJXlrY9mU8QNgJXZ22v/scene.splineswift")!

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                splineView() 
                

                Image("cosmos")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 200)
                
                 
               
                Button(action: {
                    showContentView.toggle() // Opens the fullscreen sheet
                }) {
                    Text("Explore")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 350, height: 50)
                        .background(Color.theme.purplemain)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
              
                .padding(.top, 20)
                
                
                //Spacer()
            }
        }
        .fullScreenCover(isPresented: $showContentView) {
            homeView() // Opens ContentView in full screen
        }
    }

    // Function to create the Spline scene view
    func splineView() -> some View {
        SplineView(sceneFileURL: sceneURL)
            .frame(width: 700, height: 400)
            .background(Color.black)
            .ignoresSafeArea()
    }
}

#Preview {
    launchView()
}



