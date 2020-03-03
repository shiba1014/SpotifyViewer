//
//  Auth.swift
//  Request
//
//  Created by shiba on 2020/02/29.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

public enum Auth {
    private enum Const {
        static let responseType = "code"
    }
    public static let loginUrl: URL = {
        var components = URLComponents(string: "https://accounts.spotify.com/authorize")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: ServerSettings.clientId),
            URLQueryItem(name: "response_type", value: Const.responseType),
            URLQueryItem(name: "redirect_uri", value: ServerSettings.redirectUri)
        ]
        
        return components.url!
    }()

    public static func getCode(from url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let code = components?.queryItems?.first { $0.name == Const.responseType }?.value
        return code
    }
}
