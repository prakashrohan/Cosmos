//
//  CosmosApp.swift
//  Cosmos
//
//  Created by Rohan Prakash on 15/12/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = AppState()
  var body: some Scene {
    WindowGroup {
      NavigationView {
          
          SplashScreenView()
              .environmentObject(appState)
      }
    }
  }
}
