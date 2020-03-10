//
//  Auth.swift
//  Request
//
//  Created by shiba on 2020/02/29.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import Entity
import ReactiveSwift

public enum Auth {
    private enum Const {
        static let baseURL: String = "https://accounts.spotify.com/"
        static let responseType: String = "code"
    }
    public static let loginUrl: URL = {
        var components = URLComponents(string: Const.baseURL + "authorize")!
        components.queryItems = [
            .init(name: "client_id", value: ServerSettings.clientId),
            .init(name: "response_type", value: Const.responseType),
            .init(name: "redirect_uri", value: ServerSettings.redirectUri),
            .init(name: "scope", value: "playlist-modify-public playlist-read-private playlist-modify-private")
        ]
        
        return components.url!
    }()

    public static func getCode(from url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let code = components?.queryItems?.first { $0.name == Const.responseType }?.value
        return code
    }

    public static func renewSessionIfNeeded(session: SpotifySession?) -> SignalProducer<SpotifySession, Error> {
        if let session = session {
            if session.isValid() {
                return SignalProducer.init(value: session)
            }
            else {
                return Auth.renewSession(session: session)
            }
        }
        else {
            fatalError("Need to login")
        }
    }

    public static func createSession(code: String) -> SignalProducer<SpotifySession, Error> {
        let request = GetAccessTokenRequest(code: code)
        return SpotifyClient.send(urlRequest: request.buildURLRequest())
            .attemptMap { (data, response) -> Auth.GetAccessTokenRequest.Response in
                try request.response(from: data, urlResponse: response)
        }
        .map { SpotifySession(accessToken: $0.accessToken, refreshToken: $0.refreshToken, expirationDate: Date(timeIntervalSinceNow: $0.expiresIn)) }
    }

    public static func renewSession(session: SpotifySession) -> SignalProducer<SpotifySession, Error> {
        let request = RenewAccessTokenRequest(refreshToken: session.refreshToken)
        return SpotifyClient.send(urlRequest: request.buildURLRequest())
            .attemptMap { (data, response) -> Auth.RenewAccessTokenRequest.Response in
                return try request.response(from: data, urlResponse: response)
        }
        .map { SpotifySession(accessToken: $0.accessToken, refreshToken: session.refreshToken, expirationDate: Date(timeIntervalSinceNow: $0.expiresIn)) }
    }

    private struct RenewAccessTokenRequest {
        struct Response: Codable {
                var accessToken: String
                var expiresIn: Double
            }

            var bodyParameters: [String: String]

            init(refreshToken: String) {
                bodyParameters = [
                    "grant_type": "refresh_token",
                    "refresh_token": refreshToken
                ]
            }

            func buildURLRequest() -> URLRequest {
                var urlRequest = URLRequest(url: URL(string: Const.baseURL + "api/token")!)
                urlRequest.httpMethod = "POST"

                urlRequest.addValue(ServerSettings.authorizationHeader, forHTTPHeaderField: "Authorization")
                urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")

                urlRequest.httpBody = bodyParameters.map { $0.key + "=" + $0.value }
                    .joined(separator: "&")
                    .data(using: .utf8)

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

    private struct GetAccessTokenRequest {
        struct Response: Codable {
            var accessToken: String
            var expiresIn: Double
            var refreshToken: String
        }

        var bodyParameters: [String: String]

        init(code: String) {
            bodyParameters = [
                "code": code,
                "grant_type": "authorization_code",
                "redirect_uri": ServerSettings.redirectUri
            ]
        }

        func buildURLRequest() -> URLRequest {
            var urlRequest = URLRequest(url: URL(string: Const.baseURL + "api/token")!)
            urlRequest.httpMethod = "POST"

            urlRequest.addValue(ServerSettings.authorizationHeader, forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")

            urlRequest.httpBody = bodyParameters.map { $0.key + "=" + $0.value }
                .joined(separator: "&")
                .data(using: .utf8)

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
}
