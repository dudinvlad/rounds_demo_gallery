//
//  GalleryViewModel.swift
//  DemoGallery-Rounds
//

import Foundation
import rounds_images_lib

@Observable
@MainActor
final class GalleryViewModel {
    private(set) var entries: [GalleryListEntry] = []
    private(set) var phase: Phase = .idle
    /// Bumped after cache invalidation so list rows remount and reload images from network.
    private(set) var imageRefreshEpoch = 0

    private let listFetcher: any ImageListFetching

    enum Phase: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    init(listFetcher: any ImageListFetching = ImageListService()) {
        self.listFetcher = listFetcher
    }

    func loadList() async {
        let wasEmpty = entries.isEmpty
        if wasEmpty {
            phase = .loading
        }
        do {
            let fetched = try await listFetcher.fetchItems()
            entries = GalleryListEntry.make(from: fetched)
            phase = .loaded
        } catch {
            if wasEmpty {
                phase = .failed(error.localizedDescription)
            }
        }
    }

    func clearImageCache() async {
        do {
            try await ImageLoader.shared.invalidateAll()
            imageRefreshEpoch += 1
        } catch {
            // List data is unchanged; avoid replacing the whole screen for cache/disk errors.
        }
    }
}
