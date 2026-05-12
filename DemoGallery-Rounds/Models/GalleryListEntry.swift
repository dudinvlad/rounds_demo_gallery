//
//  GalleryListEntry.swift
//  DemoGallery-Rounds
//

import Foundation

/// Stable list identity for SwiftUI: server `id` is not guaranteed unique; we include index and URL in the row id.
struct GalleryListEntry: Identifiable, Hashable, Sendable {
    let id: String
    let item: ImageListItem

    static func make(from items: [ImageListItem]) -> [GalleryListEntry] {
        items.enumerated().map { index, item in
            GalleryListEntry(
                id: "\(index)-\(item.id)-\(item.imageURL.absoluteString)",
                item: item
            )
        }
    }
}
