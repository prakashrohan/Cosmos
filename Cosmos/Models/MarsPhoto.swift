//
//  MarsPhoto.swift
//  Cosmos
//
//  Created by Rohan Prakash on 17/07/25.
//

import Foundation

struct MarsPhoto: Identifiable, Codable {
    let id: Int
    let img_src: String
    let earth_date: String
    let camera: Camera
    let rover: Rover

    struct Camera: Codable {
        let full_name: String
    }

    struct Rover: Codable {
        let name: String
        let status: String
    }
}
