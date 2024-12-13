//
//  ImageCache.swift
//  GameTest
//
//  Created by Anshika Gupta on 5/12/2024.
//

import Foundation
import UIKit
import Combine

// To make your code more extensible, Create a protocol for the cache and have your ImageCache class implement it. This way, we can easily swap out the caching implementation in the future.

protocol ImageCache {
    func getImage(for url: URL) -> UIImage?
    func saveImage(_ image: UIImage, for url: URL)
}


protocol ImageCachingClient {
    var imageCache: ImageCache { get }
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

final class DefaultImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    func getImage(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func saveImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}



