//
//  LoginViewController.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/02/28.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import UIKit
import WebKit
import Request

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

private extension LoginViewController {
    func configure() {
        let button = UIButton(frame: .zero)
        button.backgroundColor = UIColor(red: 29.0/255.0, green: 185.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Connect with Spotify", for: .normal)
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 70),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func tappedButton() {
        UIApplication.shared.open(Auth.loginUrl)
    }
}
