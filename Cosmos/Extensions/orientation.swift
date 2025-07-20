//
//  orientation.swift
//  Cosmos
//
//  Created by Rohan Prakash on 19/07/25.
//

import UIKit
import ImageIO

extension CGImagePropertyOrientation {
    
    init?(_ ui: UIImage.Orientation) {
        switch ui {
        case .up:           self = .up
        case .down:         self = .down
        case .left:         self = .left
        case .right:        self = .right
        case .upMirrored:   self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored:self = .rightMirrored
        @unknown default:   return nil
        }
    }
}
