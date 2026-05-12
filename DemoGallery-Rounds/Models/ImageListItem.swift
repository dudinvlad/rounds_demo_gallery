//
//  ImageListItem.swift
//  DemoGallery-Rounds
//

import Foundation

struct ImageListItem: Identifiable, Decodable, Hashable, Sendable {
    let id: Int
    let imageURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "imageUrl"
    }

    init(id: Int, imageURL: URL) {
        self.id = id
        self.imageURL = imageURL
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        let urlString = try container.decode(String.self, forKey: .imageURL)
        guard let url = URL(string: urlString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .imageURL,
                in: container,
                debugDescription: "Invalid image URL string"
            )
        }
        imageURL = url
    }
}
