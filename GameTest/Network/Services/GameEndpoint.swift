//
//  GameEndpoint.swift
//  GameTest
//
//  Created by Anshika Gupta on 5/12/2024.
//

import Foundation

enum GameEndpoint {
    // Add more enum if requred more service calls and pass path, method, queryItems acoordingly
    case getGames
}

extension GameEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getGames:
            return "/game-library-rest-api/getGamesByMarketAndDevice.json"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getGames:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getGames:
            return [
                URLQueryItem(name: GameAppConstants.jurisdictionHeader, value: "UK"),
                URLQueryItem(name: GameAppConstants.brandHeader, value: "unibet"),
                URLQueryItem(name: GameAppConstants.deviceGroupHeader, value: "mobilephone"),
                URLQueryItem(name: GameAppConstants.localeHeader, value: "en_GB"),
                URLQueryItem(name: GameAppConstants.currencyHeader, value: "GBP"),
                URLQueryItem(name: GameAppConstants.categoriesHeader, value: "casino,softgames"),
                URLQueryItem(name: GameAppConstants.clientIdHeader, value: "casinoapp")
            ]
        }
    }
}
