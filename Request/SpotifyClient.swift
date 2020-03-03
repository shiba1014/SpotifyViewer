//
//  SpotifyClient.swift
//  Request
//
//  Created by shiba on 2020/03/03.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import Entity
import ReactiveSwift

public enum SpotifyClient {
    public static func createSession(code: String) -> SignalProducer<SpotifySession, Error> {
        let request = GetAccessTokenRequest(code: code)
        return send(urlRequest: request.buildGetAccessKeyURLRequest())
            .attemptMap { (data, response) -> GetAccessTokenRequest.Response in
                try request.response(from: data, urlResponse: response)
        }
        .map { SpotifySession(accessToken: $0.accessToken, refreshToken: $0.refreshToken, expirationDate: Date(timeIntervalSinceNow: $0.expiresIn)) }
    }

    public static func renewSession(session: SpotifySession) -> SignalProducer<SpotifySession, Error> {
        let request = GetAccessTokenRequest(refreshToken: session.refreshToken)
        return send(urlRequest: request.buildGetAccessKeyURLRequest())
            .attemptMap { (data, response) -> GetAccessTokenRequest.Response in
                try request.response(from: data, urlResponse: response)
        }
        .map { SpotifySession(accessToken: $0.accessToken, refreshToken: $0.refreshToken, expirationDate: Date(timeIntervalSinceNow: $0.expiresIn)) }
    }

    static func send<Request: SpotifyRequest>(request: Request) -> SignalProducer<Request.Response, Error> {
        return send(urlRequest: request.buildURLRequest())
            .attemptMap { (data, response) -> Request.Response in
                try request.response(from: data, urlResponse: response)
        }
    }

    private static func send(urlRequest: URLRequest) -> SignalProducer<(Data, URLResponse), Error> {
        return .init { observer, lifetime in
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                switch (data, response, error) {
                case (_, _, let error?):
                    observer.send(error: error)

                case (let data?, let response?, _):
                    observer.send(value: (data, response))

                default:
                    observer.send(error: NSError(domain: "Unrecognized response.", code: -1, userInfo: nil))
                }

                observer.sendCompleted()
            }

            task.resume()
        }
    }
}
