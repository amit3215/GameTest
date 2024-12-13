//
//  HTTPClient.swift
//  GameTest
//
//  Created by Anshika Gupta on 5/12/2024.
//

import Foundation

import Combine
import UIKit

protocol HTTPClient {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, RequestError>
    func requestData(from url: URL) -> AnyPublisher<Data, RequestError>
}

final class ServiceManager: HTTPClient {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, RequestError> {
          do {
              let request = try endpoint.buildURLRequest()
              return URLSession.shared.dataTaskPublisher(for: request)
                  .mapError { _ in
                      RequestError.unknown
                  }
                  .flatMap { data, response -> AnyPublisher<T, RequestError> in
                      guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                          return Fail(error: RequestError.unexpectedStatusCode).eraseToAnyPublisher()
                      }
                      return Just(data)
                          .decode(type: T.self, decoder: JSONDecoder())
                          .mapError { _ in
                              RequestError.decode
                          }
                          .eraseToAnyPublisher()
                  }
                  .eraseToAnyPublisher()
          } catch {
              return Fail(error: RequestError.invalidURL).eraseToAnyPublisher()
          }
    }

    func requestData(from url: URL) -> AnyPublisher<Data, RequestError> {
         URLSession.shared.dataTaskPublisher(for: url)
             .mapError { _ in RequestError.unknown }
             .flatMap { data, response -> AnyPublisher<Data, RequestError> in
                 guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                     return Fail(error: RequestError.unexpectedStatusCode).eraseToAnyPublisher()
                 }
                 return Just(data)
                     .setFailureType(to: RequestError.self)
                     .eraseToAnyPublisher()
             }
             .eraseToAnyPublisher()
     }
}
