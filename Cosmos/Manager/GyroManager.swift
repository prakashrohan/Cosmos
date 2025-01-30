//
//  GyroManager.swift
//  Cosmos
//
//  Created by Rohan Prakash on 26/01/25.
//

import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var attitude: CMAttitude?

    func startUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { (motion, error) in
                if let motion = motion {
                    DispatchQueue.main.async {
                        self.attitude = motion.attitude
                    }
                }
            }
        } else {
            print("Device motion not available.")
        }
    }

    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}
