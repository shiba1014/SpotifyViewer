//
//  Request.swift
//  Request
//
//  Created by shiba on 2020/03/02.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import Entity

private enum Const {
    static let baseURL: String = "https://api.spotify.com/v1/"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

protocol SpotifyRequest {
    associatedtype Response: Codable

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headerFields: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var bodyParameters: [String: Any]? { get }

    func response(from data: Data, urlResponse: URLResponse) throws -> Response
}

extension SpotifyRequest {
    var baseURL: URL {
        URL(string: Const.baseURL)!
    }

    var headerFields: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var bodyParameters: [String: Any]? { nil }

    func buildURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        if let queryItems = queryItems {
            components?.queryItems = queryItems
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = method.rawValue

        headerFields?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        if let bodyParameters = bodyParameters {
            let body = try? JSONSerialization.data(withJSONObject: bodyParameters, options: [])
            urlRequest.httpBody = body
        }

        return urlRequest
    }

    func response(from data: Data, urlResponse: URLResponse) throws -> Response {
        if case (200..<300)? = (urlResponse as? HTTPURLResponse)?.statusCode {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Response.self, from: data)
        }
        else {
            throw NSError(domain: "Failed to decode response.", code: -1, userInfo: nil)
        }
    }
}

struct GetCurrentProfileRequest: SpotifyRequest {
    typealias Response = User

    var path: String = "me"
    var method: HTTPMethod = .get
    var headerFields: [String : String]?

    // TODO: SpotifyRequestのdefault implementationにしたい
    init(session: SpotifySession) {
        headerFields = [
            "Authorization": "Bearer \(session.accessToken)"
        ]
    }
}

struct GetPlaylistsListRequest: SpotifyRequest {
    private enum Const {
        static let limitCount: Int = 20
    }
    
    struct Response: Codable {
        let items: [Playlists]?
    }

    var path: String = "me/playlists"
    var method: HTTPMethod = .get
    var headerFields: [String : String]?
    var queryItems: [URLQueryItem]?

    init(limit: Int = Const.limitCount, offset: Int = 0, session: SpotifySession) {
        headerFields = [
            "Authorization": "Bearer \(session.accessToken)"
        ]

        queryItems = [
            .init(name: "limit", value: String(limit)),
            .init(name: "offset", value: String(offset)),
        ]
    }
}

struct GetPlaylistsTracksRequest: SpotifyRequest {
    private enum Const {
        static let limitCount: Int = 100
    }

    struct Response: Codable {
        var items: [Item]

        struct Item: Codable {
            var track: Track
        }
    }

    var path: String
    var method: HTTPMethod = .get
    var headerFields: [String : String]?

    init(playlistsId: String, limit: Int = Const.limitCount, offset: Int = 0, session: SpotifySession) {
        headerFields = [
            "Authorization": "Bearer \(session.accessToken)"
        ]

        path = "playlists/\(playlistsId)/tracks"
    }
}

struct RemoveTrackRequest: SpotifyRequest {
    struct Response: Codable {
        var snapshotId: String
    }

    var path: String
    var method: HTTPMethod = .delete
    var headerFields: [String : String]?
    var bodyParameters: [String : Any]?

    init(playlistsId: String, trackUri: String, position: Int, session: SpotifySession) {
        path = "playlists/\(playlistsId)/tracks"

        headerFields = [
            "Authorization": "Bearer \(session.accessToken)",
            "content-type": "application/json"
        ]

        let track: [String: Any] = [
            "uri": trackUri,
            "positions": [position]
        ]

        bodyParameters = [
            "tracks": [track]
        ]
    }
}
