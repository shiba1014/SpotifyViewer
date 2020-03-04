//
//  PlaylistsDetailHeaderCell.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/03/10.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import UIKit

class PlaylistsDetailHeaderCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: PlaylistsCell.self)
    static let cellHeight: CGFloat = 190

    private enum Const {
        static let shuffleButtonWidth: CGFloat = 212
        static let shuffleButtonHeight: CGFloat = 48
        static let addButtonWidth: CGFloat = 126
        static let addButtonHeight: CGFloat = 28
    }

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 23)
        titleLabel.textColor = .white
        return titleLabel
    }()

    private let shuffleButton: UIButton = {
        let shuffleButton = UIButton()
        shuffleButton.translatesAutoresizingMaskIntoConstraints = false
        shuffleButton.backgroundColor = SpotifyColor.green
        shuffleButton.layer.cornerRadius = Const.shuffleButtonHeight / 2
        shuffleButton.clipsToBounds = true
        shuffleButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
        shuffleButton.setTitle("SHUFFLE PLAY", for: .normal)
        return shuffleButton
    }()

    private let addButton: UIButton = {
        let addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.backgroundColor = .clear
        addButton.layer.cornerRadius = Const.addButtonHeight / 2
        addButton.layer.borderColor = SpotifyColor.gray.cgColor
        addButton.layer.borderWidth = 1
        addButton.clipsToBounds = true
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 10)
        addButton.setTitle("ADD SONGS", for: .normal)
        return addButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(playlistsName: String) {
        titleLabel.text = playlistsName
    }
}

private extension PlaylistsDetailHeaderCell {
    func configure() {
        backgroundColor = SpotifyColor.black

        addSubview(titleLabel)
        addSubview(shuffleButton)
        addSubview(addButton)

        var constraints: [NSLayoutConstraint] = []

        // Constraints for titleLabel
        constraints += [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        // Constraints for shuffleButton
        constraints += [
            shuffleButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28),
            shuffleButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            shuffleButton.widthAnchor.constraint(equalToConstant: Const.shuffleButtonWidth),
            shuffleButton.heightAnchor.constraint(equalToConstant: Const.shuffleButtonHeight)
        ]

        // Constraints for addButton
        constraints += [
            addButton.topAnchor.constraint(equalTo: shuffleButton.bottomAnchor, constant: 20),
            bottomAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 30),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: Const.addButtonWidth),
            addButton.heightAnchor.constraint(equalToConstant: Const.addButtonHeight)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
