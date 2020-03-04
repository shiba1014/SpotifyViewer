//
//  LoginViewController.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/02/28.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    private enum Const {
        static let buttonWidth: CGFloat = 212
        static let buttonHeight: CGFloat = 48
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

private extension LoginViewController {
    func configure() {
        let button = UIButton(frame: .zero)
        button.backgroundColor = SpotifyColor.green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Const.buttonHeight / 2
        button.clipsToBounds = true
        button.setTitle("Connect with Spotify", for: .normal)
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Const.buttonWidth),
            button.heightAnchor.constraint(equalToConstant: Const.buttonHeight),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func tappedButton() {
        Router.showLoginPage()
    }
}
