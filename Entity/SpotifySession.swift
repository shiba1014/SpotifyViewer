//
//  SpotifySession.swift
//  Entity
//
//  Created by shiba on 2020/03/03.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

public struct SpotifySession {
    public let accessToken: String
    public let refreshToken: String
    public let expirationDate: Date

    public func isValid() -> Bool {
        return Date().compare(expirationDate) == .orderedAscending
    }

    public init(accessToken: String, refreshToken: String, expirationDate: Date) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expirationDate = expirationDate
    }
}
