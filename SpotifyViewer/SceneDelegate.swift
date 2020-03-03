//
//  SceneDelegate.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/02/27.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import UIKit
import Request
import Repository

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.rootViewController = LoginViewController()
        window.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url,
            let code = Auth.getCode(from: url) else {
                print("Invalid URL")
                return
        }

        Repository.shared.getAccessToken(from: code).startWithResult { result in
            switch result {
            case .success(let session):
                print(session.isValid())
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

