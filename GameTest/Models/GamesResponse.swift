//
//  GamesResponse.swift
//  GameTest
//
//  Created by Anshika Gupta on 5/12/2024.
//

import Foundation

struct GamesResponse: Decodable {
    let games: [String: Game]
}
