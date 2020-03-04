//
//  ServerSettings.swift
//  Request
//
//  Created by shiba on 2020/03/03.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

enum ServerSettings {
    static let clientId: String = "c40ee47ae7af4967a53190793d61ef8a"
    static let clientSecret: String = "d230c3c727b74ea594c84916bbe4ab87"
    static let redirectUri: String = "spotify-viewer-login://callback"
    static let authorizationHeader: String = {
        let authString = "\(clientId):\(clientSecret)".data(using: .ascii)!.base64EncodedString(options: [])
        return "Basic \(authString)"
    }()
}
