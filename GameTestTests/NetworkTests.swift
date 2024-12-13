//
//  NetworkTests.swift
//  GameTestTests
//
//  Created by Anshika Gupta on 5/12/2024.
//

import XCTest
import Combine

final class NetworkTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchGamesSuccess() {
        // Mock response
        let mockResponse = """
        {
            "games": {
                "game1": {
                    "gameName": "Test Game 1",
                    "gameId": "game1",
                    "playUrl": "/play/test-game-1",
                    "pathSegment": "test-game-1",
                    "launchLocale": "en_GB",
                    "imageUrl": "https://example.com/game1.jpg",
                    "backgroundImageUrl": "https://example.com/game1.jpg",
                    "tags": ["tag1", "tag2"],
                    "vendorId": "vendor1",
                    "displayVendorName": "Vendor Name 1",
                    "vendor": {
                        "name": "Vendor 1",
                        "vendorGroupId": "vg1"
                    },
                    "subVendor": {
                        "name": "Sub Vendor 1",
                        "id": "sv1"
                    },
                    "licenses": ["license1"],
                    "typeSettings": {
                        "maxLines": "10",
                        "noOfReels": 5,
                        "noOfRows": 3,
                        "volatility": "medium"
                    }
                }
            }
        }
        """.data(using: .utf8)!

        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.mockData = mockResponse

        let gameService = GameService(httpClient: mockHTTPClient)

        // Act
        let expectation = XCTestExpectation(description: "Fetch games successfully")
        var fetchedGames: [Game]?

        gameService.fetchGames()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { games in
                fetchedGames = games
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)

        // Assert
        XCTAssertEqual(fetchedGames?.count, 1)
        XCTAssertEqual(fetchedGames?.first?.gameName, "Test Game 1")
        XCTAssertEqual(fetchedGames?.first?.gameId, "game1")
    }
    
    func testFetchGamesDecodingFailure() {
        // Mock invalid response (missing required fields)
        let mockResponse = """
        {
            "games": {
                "game1": {
                    "gameName": "Test Game 1"
                    // Missing required fields like gameId, tags, etc.
                }
            }
        }
        """.data(using: .utf8)!

        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.mockData = mockResponse

        let gameService = GameService(httpClient: mockHTTPClient)

        // Act
        let expectation = XCTestExpectation(description: "Fetch games decoding failure")
        var errorMessage: String?

        gameService.fetchGames()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    errorMessage = error.localizedDescription
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got success")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)

        // Assert
        XCTAssertEqual(errorMessage, "The operation couldn’t be completed. (GameTestTests.RequestError error 0.)")
    }
    
    func testLoadImageCacheHit() {
        // Given
        let imageURL = URL(string: "https://example.com/image.jpg")!
        
        // Create a simple mock image for the test
        let cachedImage = createMockImage()
        
        let mockImageCache = MockImageCache()
        mockImageCache.saveImage(cachedImage, for: imageURL) // Save mock image in cache
        
        let mockHTTPClient = MockHTTPClient()
        let gameService = GameService(httpClient: mockHTTPClient, imageCache: mockImageCache)
        
        // Act
        let expectation = XCTestExpectation(description: "Image loaded from cache")
        var loadedImage: UIImage?
        
        gameService.loadImage(from: imageURL)
            .sink(receiveValue: { image in
                loadedImage = image
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
        
        // Assert
        XCTAssertEqual(loadedImage?.size, cachedImage.size) // Check if cached image is returned
        XCTAssertEqual(loadedImage?.cgImage, cachedImage.cgImage) // Check if the images match
    }

    func testLoadImageFailure() {
        // Given
        let imageURL = URL(string: "https://example.com/image.jpg")!
        
        // Mocking the HTTPClient to simulate a failure scenario (network error)
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.mockError = .networkError  // Simulate failure by setting mockError
        
        let mockImageCache = MockImageCache()
        let gameService = GameService(httpClient: mockHTTPClient, imageCache: mockImageCache)
        
        // Act
        let expectation = XCTestExpectation(description: "Image load should fail")
        var loadedImage: UIImage?
        
        gameService.loadImage(from: imageURL)
            .sink(receiveValue: { image in
                loadedImage = image
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
        
        // Assert
        XCTAssertNil(loadedImage) // The image should be nil because of the failure
    }


}
