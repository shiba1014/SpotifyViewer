//
//  PlaylistsDetailDownloadCell.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/03/10.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import UIKit

class PlaylistsDetailDownloadCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: PlaylistsDetailDownloadCell.self)
    static let cellHeight: CGFloat = 63

    private let downloadLabel: UILabel = {
        let downloadLabel = UILabel()
        downloadLabel.translatesAutoresizingMaskIntoConstraints = false
        downloadLabel.font = .boldSystemFont(ofSize: 16)
        downloadLabel.text = "Download"
        downloadLabel.textColor = .white
        return downloadLabel
    }()

    private let downloadSwitch: UISwitch = {
        let downloadSwitch = UISwitch()
        downloadSwitch.translatesAutoresizingMaskIntoConstraints = false
        downloadSwitch.backgroundColor = SpotifyColor.gray
        downloadSwitch.layer.cornerRadius = downloadSwitch.frame.height / 2
        downloadSwitch.tintColor = SpotifyColor.gray
        downloadSwitch.onTintColor = SpotifyColor.green
        return downloadSwitch
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PlaylistsDetailDownloadCell {
    func configure() {
        backgroundColor = SpotifyColor.black

        addSubview(downloadLabel)
        addSubview(downloadSwitch)

        var constraints: [NSLayoutConstraint] = []

        // Constraints for downloadLabel
        constraints += [
            downloadLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            downloadLabel.centerYAnchor.constraint(equalTo: downloadSwitch.centerYAnchor)
        ]

        // Constraints for downloadSwitch
        constraints += [
            downloadSwitch.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            rightAnchor.constraint(equalTo: downloadSwitch.rightAnchor, constant: 14)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
