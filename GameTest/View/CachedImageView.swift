//
//  CachedImageView.swift
//  GameTest
//
//  Created by Anshika Gupta on 5/12/2024.
//

import SwiftUI
import Combine

struct CachedImageView: View {
    @State private var image: UIImage? = nil
    @State private var subscriptions = Set<AnyCancellable>()
    private let url: URL?
    private let gameService: ImageCachingClient

    init(url: URL?, gameService: ImageCachingClient) {
        self.url = url
        self.gameService = gameService
    }

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
        .frame(width: GameAppConstants.defaultWidth, height: GameAppConstants.defaultHeight)
        .clipShape(RoundedRectangle(cornerRadius: GameAppConstants.defaultCornerRadius))
    }

    private func loadImage() {
        guard let url = url else { return }
        gameService.loadImage(from: url)
            .receive(on: DispatchQueue.main)
            .sink {  loadedImage in
                self.image = loadedImage
            }
            .store(in: &subscriptions)
    }
}

