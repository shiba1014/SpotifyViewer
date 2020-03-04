//
//  Playlists.swift
//  Entity
//
//  Created by shiba on 2020/03/09.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

public struct Playlists: Codable {
    public var id: String
    public var name: String
    public var images: [Image]
    public var owner: User
    public var snapshotId: String
}
