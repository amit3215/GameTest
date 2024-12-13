//
//  Endpoint.swift
//  GameTest
//
//  Created by Anshika Gupta on 5/12/2024.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    var scheme: String { "https" }
    var host: String { "api.unibet.com" } // Default host
    var headers: [String: String]? { ["Content-Type": "application/json;charset=utf-8"] } // Default headers but can be moved to Service Endpoint enum if headers can be changed for other request
    var body: [String: Any]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    
    func buildURLRequest() throws -> URLRequest {
        guard var components = URLComponents(string: "\(scheme)://\(host)\(path)") else {
            throw RequestError.invalidURL
        }
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        }
        return request
    }
}
