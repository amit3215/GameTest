//
//  MockImageCache.swift
//  GameTestTests
//
//  Created by Anshika Gupta on 5/12/2024.
//

import Foundation
import UIKit

class MockImageCache: ImageCache {
    var cache = [URL: UIImage]()
    
    func getImage(for url: URL) -> UIImage? {
        return cache[url]
    }
    
    func saveImage(_ image: UIImage, for url: URL) {
        cache[url] = image
    }
}
