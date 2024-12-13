//
//  GameViewModelTests.swift
//  GameTestTests
//
//  Created by Anshika Gupta on 5/12/2024.
//

import XCTest
import Combine

final class GameViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cancellables = Set<AnyCancellable>()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables = nil
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
    
    // MARK: - Success Case
    func testLoadGamesSuccess() {
        // Given
        let mockHTTPClient = MockHTTPClient()
        
        // Mock successful response
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
        
        mockHTTPClient.mockData = mockResponse
        
        let gameService = GameService(httpClient: mockHTTPClient)
        let viewModel = GameViewModel(gameService: gameService)
        
        // Act
        let expectation = XCTestExpectation(description: "Games should be loaded successfully")
        
        viewModel.$games
            .dropFirst() // Skip initial empty state
            .sink { games in
                if !games.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadGames()
        
        wait(for: [expectation], timeout: 2.0)
        
        // Assert
        XCTAssertEqual(viewModel.games.count, 1)
        XCTAssertEqual(viewModel.games.first?.gameName, "Test Game 1")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    // MARK: - Failure Case
    func testLoadGamesFailure() {
        let mockHTTPClient = MockHTTPClient()
        
        // Mock error response
        mockHTTPClient.mockError = .unknown
        
        let gameService = GameService(httpClient: mockHTTPClient)
        let viewModel = GameViewModel(gameService: gameService)

        
        // Act
        let expectation = XCTestExpectation(description: "Error message should be set on failure")
        
        viewModel.$errorMessage
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadGames()
        
        wait(for: [expectation], timeout: 2.0)
        
        // Assert
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "The operation couldn’t be completed. (GameTestTests.RequestError error 5.)")
        XCTAssertFalse(viewModel.isLoading)
    }

}
