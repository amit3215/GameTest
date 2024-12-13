//
//  ContentView.swift
//  GameTest
//
//  Created by Anshika Gupta on 5/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    private let gameService = GameService(imageCache: DefaultImageCache())
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    // Show loader view while waiting for the network call
                    ProgressView(GameAppConstants.gameScreenLoaderTitle)
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    // Show all images with name, Created CachedImageView to implememnt the cache mechanism
                    List(viewModel.games, id: \.gameId) { game in
                        HStack {
                            CachedImageView(url: game.imageUrl.flatMap { URL(string: $0) }, gameService: gameService)
                                .frame(width: GameAppConstants.defaultWidth, height: GameAppConstants.defaultHeight)
                            Text(game.gameName) // Corrected to use `gameName`
                                .font(.headline)
                        }
                    }
                    .navigationTitle(GameAppConstants.gameSreenTitle)
                    .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                        Alert(title: Text(GameAppConstants.gameSreenError), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text(GameAppConstants.gameSreenOkLabel)))
                    }
                }
            }
            .task {
                viewModel.loadGames()
            }
        }
    }
}

#Preview {
    ContentView()
}
