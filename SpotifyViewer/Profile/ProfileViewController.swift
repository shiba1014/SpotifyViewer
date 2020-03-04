//
//  ProfileViewController.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/03/04.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Repository
import UIKit

class ProfileViewController: UIViewController {
    private enum Const {
        static let buttonWidth: CGFloat = 212
        static let buttonHeight: CGFloat = 48
    }

    private let displayNameProperty: MutableProperty<String> = .init("---")

    init() {
        super.init(nibName: nil, bundle: nil)

        displayNameProperty <~ Repository.shared.getDisplayName()
            .flatMapError{ _ in .init(value: "Failed to load display name.") }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

private extension ProfileViewController {
    func configure() {
        view.backgroundColor = SpotifyColor.black

        let nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "---"
        nameLabel.reactive.text <~ displayNameProperty
        view.addSubview(nameLabel)

        let logoutButton = UIButton()
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.backgroundColor = SpotifyColor.green
        // TODO: Figma上の数字と合わない
        logoutButton.layer.cornerRadius = Const.buttonHeight / 2
        logoutButton.clipsToBounds = true
        logoutButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
        logoutButton.setTitle("LOG OUT", for: .normal)
        logoutButton.addTarget(self, action: #selector(tappedLogout), for: .touchUpInside)
        view.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            logoutButton.widthAnchor.constraint(equalToConstant: Const.buttonWidth),
            logoutButton.heightAnchor.constraint(equalToConstant: Const.buttonHeight)
        ])
    }

    @objc func tappedLogout() {
        let alert = UIAlertController(title: "ログアウトします", message: "よろしいですか？", preferredStyle: .alert)
        let logout = UIAlertAction(title: "ログアウト", style: .destructive) { _ in
            Router.logout()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(logout)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
