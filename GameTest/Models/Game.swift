//
//  Game.swift
//  GameTest
//
//  Created by Anshika Gupta on 5/12/2024.
//

import Foundation

struct Game: Decodable {
    let gameId: String
    let gameName: String
    let playUrl: String?
    let pathSegment: String?
    let launchLocale: String?
    let imageUrl: String?
    let backgroundImageUrl: String?
    let tags: [String]?
    let vendorId: String?
    let displayVendorName: String?
    let vendor: Vendor?
    let subVendor: SubVendor?
    let licenses: [String]?
    let typeSettings: TypeSettings?
}

