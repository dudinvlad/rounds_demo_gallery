//
//  ImageListService.swift
//  DemoGallery-Rounds
//

import Foundation

/// Loads the remote JSON catalog. Isolated from view models for testing and single responsibility.
protocol ImageListFetching: Sendable {
    func fetchItems() async throws -> [ImageListItem]
}

struct ImageListService: ImageListFetching {
    private let session: URLSession
    private let listURL: URL
    private let decoder: JSONDecoder

    nonisolated init(
        session: URLSession = .galleryCatalog(),
        listURL: URL = ImageListEndpoint.jsonURL,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.listURL = listURL
        self.decoder = decoder
    }

    func fetchItems() async throws -> [ImageListItem] {
        let (data, response) = try await session.data(from: listURL)
        if let http = response as? HTTPURLResponse, !(200 ..< 300).contains(http.statusCode) {
            throw ImageListServiceError.httpStatus(http.statusCode)
        }
        return try decoder.decode([ImageListItem].self, from: data)
    }
}

enum ImageListServiceError: Error, LocalizedError {
    case httpStatus(Int)

    var errorDescription: String? {
        switch self {
        case .httpStatus(let code):
            return "Server returned status \(code)."
        }
    }
}
