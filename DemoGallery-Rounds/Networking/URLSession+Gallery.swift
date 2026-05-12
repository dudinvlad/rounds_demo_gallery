//
//  URLSession+Gallery.swift
//  DemoGallery-Rounds
//

import Foundation

extension URLSession {
    /// Shared defaults for catalog fetches: bounded timeouts and connectivity waits.
    nonisolated static func galleryCatalog() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration)
    }
}
