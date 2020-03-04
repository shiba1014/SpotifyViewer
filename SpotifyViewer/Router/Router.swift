//
//  Router.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/03/04.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import Entity
import ReactiveSwift
import Repository
import Request
import UIKit

final class Router {
    static let rootViewController = RootViewController()
}

// MARK: Login / Logout Routing
extension Router {
    static func showLoginPage() {
        UIApplication.shared.open(Auth.loginUrl)
    }

    static func handle(url: URL) {
        guard let code = Auth.getCode(from: url) else {
            showError(message: "Invalid URL.")
            return
        }

        Repository.shared.getAccessToken(from: code)
            .observe(on: UIScheduler())
            .startWithResult { result in
                switch result {
                case .success:
                    rootViewController.moveToMain()

                case .failure(let error):
                    print(error.localizedDescription)
                    showError(message: "Failed to login.")
                }
        }
    }

    static func logout() {
        Repository.shared.logout()
        rootViewController.moveToLogin()
    }
}

extension Router {
    static func showError(message: String) {
        rootViewController.showError(message: message)
    }

    static func pushToDetail(playlists: Playlists) {
        rootViewController.pushToDetail(playlists: playlists)
    }

    static func showCreatePlaylist() {
        rootViewController.showCreatePlaylist()
    }
}

final class RootViewController: UIViewController {

    private var current: UIViewController

    fileprivate init() {
        current = UIViewController()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if Repository.shared.hasLogin() {
            moveToMain()
        }
        else {
            moveToLogin()
        }
    }
}

fileprivate extension RootViewController {
    func moveToLogin() {
        move(to: LoginViewController())
    }

    func moveToMain() {
        move(to: TabBarController())
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }

    func pushToDetail(playlists: Playlists) {
        // TODO: 微妙な書き方な気がする
        let playlistsDetail = PlaylistsDetailViewController(playlists: playlists)
        guard let tab = current as? TabBarController,
            let nav = tab.selectedViewController as? UINavigationController else { return }
        nav.pushViewController(playlistsDetail, animated: true)
    }

    func showCreatePlaylist() {
        let alert = UIAlertController(title: "Create playlist", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

private extension RootViewController {
    func move(to new: UIViewController) {
        addChild(new)
        new.view.frame = view.bounds
        view.addSubview(new.view)
        new.didMove(toParent: self)

        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()

        current = new
    }
}
