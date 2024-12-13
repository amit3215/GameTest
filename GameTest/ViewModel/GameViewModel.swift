//
//  GameViewModel.swift
//  GameTest
//
//  Created by Anshika Gupta on 5/12/2024.
//

import Foundation
import Combine

final class GameViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let gameService: GameServiceProtocol

    init(gameService: GameServiceProtocol = GameService()) {
        self.gameService = gameService
    }

    func loadGames() {
        self.isLoading = true
        gameService.fetchGames()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] games in
                self?.isLoading = false
                self?.games = games
            }
            .store(in: &cancellables)
    }
}
