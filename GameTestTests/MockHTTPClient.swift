//
//  MockHTTPClient.swift
//  GameTestTests
//
//  Created by Anshika Gupta on 5/12/2024.
//

import Foundation
import Combine
import XCTest

final class MockHTTPClient: HTTPClient {
    var mockData: Data?
    var mockError: RequestError?

    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, RequestError> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }

        guard let data = mockData else {
            return Fail(error: .unknown).eraseToAnyPublisher()
        }

        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return Just(decoded)
                .setFailureType(to: RequestError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: .decode).eraseToAnyPublisher()
        }
    }

    func requestData(from url: URL) -> AnyPublisher<Data, RequestError> {
        // Not needed for this test
        Fail(error: .unknown).eraseToAnyPublisher()
    }
}

func createMockImage() -> UIImage {
    // Create a simple 1x1 pixel image
    let size = CGSize(width: 1, height: 1)
    UIGraphicsBeginImageContext(size)
    UIColor.red.setFill()  // Fill with a red color
    UIRectFill(CGRect(origin: .zero, size: size))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}
