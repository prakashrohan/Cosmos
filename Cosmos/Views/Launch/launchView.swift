//
//  SwiftUIView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 16/01/25.
//

import SwiftUI
import SplineRuntime

struct launchView: View {
    let sceneURL = URL(string: "https://build.spline.design/ixJXlrY9mU8QNgJXZ22v/scene.splineswift")!

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                splineView() // Function to display the Spline scene
                //Spacer()
                Text("Cosmos")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(.top)
                
                Spacer()
                
               
                
                Spacer()
            }
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

//let url = URL(string: "https://build.spline.design/ixJXlrY9mU8QNgJXZ22v/scene.splineswift")
