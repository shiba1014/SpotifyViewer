//
//  Request.swift
//  Request
//
//  Created by shiba on 2020/03/02.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import Entity

private enum Const {
    static let baseUrl: String = "https://accounts.spotify.com/api/"
    static let authorizationHeader: String = {
        let authString = "\(ServerSettings.clientId):\(ServerSettings.clientSecret)".data(using: .ascii)!.base64EncodedString(options: [])
        return "Basic \(authString)"
    }()
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol SpotifyRequest {
    associatedtype Response: Codable

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headerFields: [String: String]? { get }
    var bodyParameters: [String: String]? { get }
}

extension SpotifyRequest {
    var baseURL: URL {
        URL(string: Const.baseUrl)!
    }

    var queryItems: [URLQueryItem]? { nil }
    var headerFields: [String: String]? { nil }
    var bodyParameters: [String: String]? { nil }

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
            return try JSONDecoder().decode(Response.self, from: data)
        }
        else {
            throw NSError(domain: "Failed to decode response.", code: -1, userInfo: nil)
        }
    }
}

// renewと共通化

struct GetAccessTokenRequest: SpotifyRequest {
    struct Response: Codable {
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case expiresIn = "expires_in"
            case refreshToken = "refresh_token"
        }

        let accessToken: String
        let expiresIn: Double
        let refreshToken: String
    }

    var path: String = "token"
    var method: HTTPMethod = .post
    var headerFields: [String : String]? = [
        "Authorization": Const.authorizationHeader,
        "content-type": "application/x-www-form-urlencoded"
    ]
    var bodyParameters: [String: String]?

    init(code: String) {
        bodyParameters = [
            "code": code,
            "grant_type": "authorization_code",
            "redirect_uri": ServerSettings.redirectUri
        ]
    }

    init(refreshToken: String) {
        bodyParameters = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
    }

    func buildGetAccessKeyURLRequest() -> URLRequest {
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
            urlRequest.httpBody = bodyParameters.map { $0.key + "=" + $0.value }
                .joined(separator: "&")
                .data(using: .utf8)
        }

        return urlRequest
    }
}
