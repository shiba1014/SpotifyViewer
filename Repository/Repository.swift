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

public struct Repository {
    public static let shared = Repository()

    private var session: SpotifySession?
    private init() {}

    public func getAccessToken(from code: String) -> SignalProducer<SpotifySession, Error> {
        if let session = session {
            if session.isValid() {
                return .init { observer, lifetime in
                    observer.send(value: session)
                    observer.sendCompleted()
                }
            }
            else {
                return SpotifyClient.renewSession(session: session)
            }
        }
        else {
            return SpotifyClient.createSession(code: code)
        }
    }
}
