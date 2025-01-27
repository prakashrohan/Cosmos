//
//  ARCoachingOverlayView .swift
//  Cosmos
//
//  Created by Rohan Prakash on 26/01/25.
//

import ARKit
import RealityKit

extension ARCoachingOverlayView {
    func setup(for view: ARView, goal: ARCoachingOverlayView.Goal) {
        self.session = view.session
        self.goal = goal
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

