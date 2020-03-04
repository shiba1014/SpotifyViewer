//
//  TabBarController.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/03/04.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

private extension TabBarController {
    func configure() {
        let playlistsList = PlaylistsListViewController()
        playlistsList.view.backgroundColor = SpotifyColor.black
        playlistsList.title = "Music"
        let nav = UINavigationController(rootViewController: playlistsList)
        nav.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        nav.navigationBar.barStyle = .black
        nav.navigationBar.tintColor = .white
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        let profile = ProfileViewController()
        profile.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)

        viewControllers = [nav, profile]

        tabBar.tintColor = .white
        tabBar.barTintColor = SpotifyColor.black
    }
}
