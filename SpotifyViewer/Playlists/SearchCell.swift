//
//  SearchCell.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/03/10.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import Entity
import UIKit

class SearchCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: SearchCell.self)
    static let cellHeight: CGFloat = 52

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = .init()
        searchBar.backgroundColor = .clear
        return searchBar
    }()

    private let filtersButton: UIButton = {
        let filtersButton = UIButton()
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        filtersButton.backgroundColor = SpotifyColor.gray
        filtersButton.layer.cornerRadius = 3
        filtersButton.clipsToBounds = true
        filtersButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        filtersButton.setTitle("Filters", for: .normal)
        filtersButton.setTitleColor(SpotifyColor.lightGray, for: .normal)
        return filtersButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(placeholder: String) {
        searchBar.textField?.placeholder = placeholder
        searchBar.textField?.backgroundColor = SpotifyColor.gray
    }
}

private extension SearchCell {
    func configure() {
        backgroundColor = SpotifyColor.black
        isUserInteractionEnabled = false

        addSubview(searchBar)
        addSubview(filtersButton)

        var constraints: [NSLayoutConstraint] = []

        // Constraints for searchBar
        constraints += [
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        // Constraints for filtersButton
        constraints += [
            filtersButton.widthAnchor.constraint(equalToConstant: 70),
            filtersButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            filtersButton.leftAnchor.constraint(equalTo: searchBar.rightAnchor),
            rightAnchor.constraint(equalTo: filtersButton.rightAnchor, constant: 8),
            bottomAnchor.constraint(equalTo: filtersButton.bottomAnchor, constant: 8)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

private extension UISearchBar {
    var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        } else {
            return value(forKey: "_searchField") as? UITextField
        }
    }
}
