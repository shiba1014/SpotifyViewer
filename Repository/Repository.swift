//
//  Repository.swift
//  Repository
//
//  Created by shiba on 2020/03/03.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import Entity
import ReactiveSwift
import Request

public class Repository {
    public static let shared = Repository()

    private enum Const {
        static let sessionKey = "currentSpotifySession"
    }

    private enum Request {
        case getDiplayName
    }

    // TODO: SpotifyClientで持った方がいいのかな
    private var session: SpotifySession? {
        didSet {
            save(session: session)
        }
    }

    private init() {
        if let data = UserDefaults.standard.object(forKey: Const.sessionKey) as? Data,
            let session = try? JSONDecoder().decode(SpotifySession.self, from: data) {
            self.session = session
        }
    }

    public func getAccessToken(from code: String) -> SignalProducer<String, Error> {
        if let session = session {
            if session.isValid() {
                return .init(value: session.accessToken)
            }
            else {
                return Auth.renewSession(session: session)
                    .map { [weak self] session in
                        self?.session = session
                        return session.accessToken
                }
            }
        }
        else {
            return Auth.createSession(code: code)
                .map { [weak self] session in
                    self?.session = session
                    return session.accessToken
            }
        }
    }

    public func getDisplayName() -> SignalProducer<String, Error> {
        Auth.renewSessionIfNeeded(session: session)
            .flatMap(.concat) { SpotifyClient.getDisplayName(session: $0) }
    }

    public func getPlaylistsList() -> SignalProducer<[Playlists], Error> {
        Auth.renewSessionIfNeeded(session: session)
            .flatMap(.concat) { SpotifyClient.getPlaylistsList(session: $0) }
    }

    public func getPlaylistsTracks(playlistsId: String) -> SignalProducer<[Track], Error> {
        Auth.renewSessionIfNeeded(session: session)
            .flatMap(.concat) { SpotifyClient.getPlaylistsTracks(playlistsId: playlistsId, session: $0) }
    }

    public func getImage(from url: URL) -> SignalProducer<UIImage?, Error> {
        SpotifyClient.getImage(from: url)
    }

    public func removeTrack(playlistsId: String, trackUri: String, position: Int) -> SignalProducer<(), Error> {
        Auth.renewSessionIfNeeded(session: session)
            .flatMap(.concat) {
                SpotifyClient.removeTrack(playlistsId: playlistsId, trackUri: trackUri, position: position, session: $0)
        }
    }

    public func hasLogin() -> Bool {
        return session != nil
    }

    public func logout() {
        session = nil
        UserDefaults.standard.removeObject(forKey: Const.sessionKey)
    }

    private func save(session: SpotifySession?) {
        if let data = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(data, forKey: Const.sessionKey)
        }
    }
}
