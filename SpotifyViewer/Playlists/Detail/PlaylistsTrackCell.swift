//
//  PlaylistsTrackCell.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/03/10.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import Entity
import UIKit

class PlaylistsTrackCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: PlaylistsTrackCell.self)
    static let cellHeight: CGFloat = 64

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .white
        return titleLabel
    }()

    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = SpotifyColor.lightGray
        return descriptionLabel
    }()

    private let labelStackView: UIStackView = {
        let labelStackView = UIStackView()
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.spacing = 6
        return labelStackView
    }()

    private let optionButton: UIButton = {
        let optionButton = UIButton()
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        optionButton.setImage(UIImage(named: "Dots"), for: .normal)
        return optionButton
    }()

    private var handler: () -> Void = { }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(track: Track, handler: @escaping () -> Void) {
        titleLabel.text = track.name
        descriptionLabel.text = track.description
        self.handler = handler
    }
}

private extension PlaylistsTrackCell {
    func configure() {
        backgroundColor = SpotifyColor.black

        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(descriptionLabel)

        optionButton.reactive.controlEvents(.touchUpInside)
            .observe { [weak self] _ in
                self?.handler()
        }

        addSubview(labelStackView)
        addSubview(optionButton)

        var constraints: [NSLayoutConstraint] = []

        // Constraints for labelStackView
        constraints += [
//            labelStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            labelStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
//            bottomAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 16)
        ]

        // Constraints for optionButton
        constraints += [
            optionButton.widthAnchor.constraint(equalToConstant: 24),
            optionButton.heightAnchor.constraint(equalTo: optionButton.widthAnchor),
            optionButton.leftAnchor.constraint(equalTo: labelStackView.rightAnchor, constant: 12),
            rightAnchor.constraint(equalTo: optionButton.rightAnchor, constant: 12),
            optionButton.centerYAnchor.constraint(equalTo: labelStackView.centerYAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

private extension Track {
    var description: String {
        artists.map { $0.name }.joined(separator: ", ") + "・" + album.name
    }
}
