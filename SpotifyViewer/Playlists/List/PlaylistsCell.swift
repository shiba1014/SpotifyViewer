//
//  PlaylistsCell.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/03/09.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import AlamofireImage
import Entity
import UIKit

class PlaylistsCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: PlaylistsCell.self)
    static let cellHeight: CGFloat = 72

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        // TODO: placeholderのimageがあるかも
        return imageView
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        return titleLabel
    }()

    private let ownerLabel: UILabel = {
        let ownerLabel = UILabel()
        ownerLabel.translatesAutoresizingMaskIntoConstraints = false
        ownerLabel.font = .systemFont(ofSize: 12)
        ownerLabel.textColor = SpotifyColor.lightGray
        return ownerLabel
    }()

    private let labelStackView: UIStackView = {
        let labelStackView = UIStackView()
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.spacing = 3
        return labelStackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(playlists: Playlists) {
        if let thumbnailURL = playlists.thumbnailURL {
            imageView.af.setImage(
                withURL: thumbnailURL,
                imageTransition: .crossDissolve(0.2)
            )
        }
        titleLabel.text = playlists.name
        ownerLabel.text = "by \(playlists.owner.displayName)"
        ownerLabel.isHidden = false
    }

    func setCreatePlaylist() {
        imageView.image = UIImage(named: "AddPlaylist")
        titleLabel.text = "Create playlist"
        ownerLabel.isHidden = true
    }
}

private extension PlaylistsCell {
    func configure() {
        backgroundColor = SpotifyColor.black

        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(ownerLabel)

        addSubview(imageView)
        addSubview(labelStackView)

        var constraints: [NSLayoutConstraint] = []

        // Constraints for imageView
        constraints += [
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ]

        // Constraints for labelStackView
        constraints += [
            labelStackView.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 12),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightAnchor.constraint(equalTo: labelStackView.rightAnchor, constant: 24)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

private extension Playlists {
    var thumbnailURL: URL? {
        // Use last image because the images are returned by size in descending order.
        // ref: https://developer.spotify.com/documentation/web-api/reference/playlists/get-a-list-of-current-users-playlists/
        guard let urlStr = images.last?.url else { return nil }
        return URL(string: urlStr)
    }
}
