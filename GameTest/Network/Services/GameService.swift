//
//  GameService.swift
//  GameTest
//
//  Created by Anshika Gupta on 5/12/2024.
//

import Foundation
import Combine
import UIKit

protocol GameServiceProtocol {
    func fetchGames() -> AnyPublisher<[Game], RequestError>
}

final class GameService: GameServiceProtocol, ImageCachingClient {
    let imageCache: ImageCache
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = ServiceManager(), imageCache: ImageCache = DefaultImageCache()) {
        self.imageCache = imageCache
        self.httpClient = httpClient
    }
    
    func fetchGames() -> AnyPublisher<[Game], RequestError> {
        httpClient.request(GameEndpoint.getGames)
            .map { (gamesResponse: GamesResponse) in
                Array(gamesResponse.games.values) // Convert dictionary to an array of games
            }
            .handleEvents(
                receiveSubscription: { subscription in
                    print(subscription)
                }
            )
            .eraseToAnyPublisher()
    }

    // Conforming to ImageCachingClient
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        // First, check if the image is already cached
        if let cachedImage = imageCache.getImage(for: url) {
            return Just(cachedImage).eraseToAnyPublisher()
        }
        
        // Delegate network fetching to HTTPClient
        return httpClient.requestData(from: url)
            .map { UIImage(data: $0) }
            .catch { _ in Just(nil) }
            .handleEvents(receiveOutput: { image in
                if let image = image {
                    self.imageCache.saveImage(image, for: url)
                }
            })
            .eraseToAnyPublisher()
    }
}
