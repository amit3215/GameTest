//
//  RequestError.swift
//  GameTest
//
//  Created by Anshika Gupta on 5/12/2024.
//

import Foundation

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    case networkError
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        case .networkError:
            return "Network Error"
        default:
            return "Unknown error"
        }
    }
}
