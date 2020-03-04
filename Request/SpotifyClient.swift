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
    public static func getDisplayName(session: SpotifySession) -> SignalProducer<String, Error> {
        send(request: GetCurrentProfileRequest(session: session)).map { $0.displayName }
    }

    public static func getPlaylistsList(session: SpotifySession) -> SignalProducer<[Playlists], Error> {
        send(request: GetPlaylistsListRequest(session: session)).map { $0.items ?? [] }
    }

    public static func getPlaylistsTracks(playlistsId: String, session: SpotifySession) -> SignalProducer<[Track], Error> {
        send(request: GetPlaylistsTracksRequest(playlistsId: playlistsId, session: session)).map { $0.items.map { $0.track } }
    }

    public static func removeTrack(playlistsId: String, trackUri: String, position: Int, session: SpotifySession) -> SignalProducer<(), Error> {
        send(request: RemoveTrackRequest(playlistsId: playlistsId, trackUri: trackUri, position: position, session: session)).map { _ in }
    }

    static func send<Request: SpotifyRequest>(request: Request) -> SignalProducer<Request.Response, Error> {
        send(urlRequest: request.buildURLRequest())
            .attemptMap { (data, response) -> Request.Response in
                try request.response(from: data, urlResponse: response)
        }
    }

    static func send(urlRequest: URLRequest) -> SignalProducer<(Data, URLResponse), Error> {
        .init { observer, lifetime in
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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

    public static func getImage(from url: URL) -> SignalProducer<UIImage?, Error> {
        .init { observer, lifetime in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                switch (data, response, error) {
                case (_, _, let error?):
                    observer.send(error: error)

                case (let data?, _, _):
                    observer.send(value: UIImage(data: data))

                default:
                    observer.send(error: NSError(domain: "Unrecognized response.", code: -1, userInfo: nil))
                }
                observer.sendCompleted()
            }
            task.resume()
        }
    }
}
