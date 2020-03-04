//
//  Track.swift
//  Entity
//
//  Created by shiba on 2020/03/10.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

public struct Track: Codable {
    public var id: String
    public var name: String
    public var album: Album
    public var artists: [Artists]
    public var uri: String
}

public struct Album: Codable {
    public var id: String
    public var name: String
}

public struct Artists: Codable {
    public var id: String
    public var name: String
}
