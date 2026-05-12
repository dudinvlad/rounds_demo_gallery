//
//  GalleryCard.swift
//  DemoGallery-Rounds
//

import SwiftUI
import UIKit
import rounds_images_lib

struct GalleryCard: View {
    let item: ImageListItem
    let imageRefreshEpoch: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundsImages.AsyncImageView(
                url: item.imageURL,
                placeholder: Image(systemName: "photo")
            )
            .frame(maxWidth: .infinity)
            .frame(height: 220)
            .background(Color(.secondarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .id("\(item.id)-\(imageRefreshEpoch)")

            Text("ID \(item.id)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color(.separator).opacity(0.35), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}

#Preview {
    GalleryCard(
        item: ImageListItem(id: 0, imageURL: URL(string: "https://zipoapps-storage-test.nyc3.digitaloceanspaces.com/2977101.jpg")!),
        imageRefreshEpoch: 0
    )
    .padding()
}
