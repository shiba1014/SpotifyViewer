//
//  PlaylistsListViewController.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/03/09.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import Entity
import ReactiveSwift
import Repository
import UIKit

class PlaylistsListViewController: UIViewController {
    private enum Section: Int, CaseIterable {
        case search
        case addPlaylist
        case playlists
    }

    private let playlistsList: MutableProperty<[Playlists]> = .init([])

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
        collectionView.register(PlaylistsCell.self, forCellWithReuseIdentifier: PlaylistsCell.reuseIdentifier)

        return collectionView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)

        // TODO: Paging処理
        playlistsList <~ Repository.shared.getPlaylistsList()
            .flatMapError { error in
                print(error.localizedDescription)
                return .init(value: [])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

private extension PlaylistsListViewController {
    func configure() {
        view.backgroundColor = SpotifyColor.black

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reactive.reloadData <~ playlistsList.map { _ in }

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PlaylistsListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .search:
            return 1

        case .addPlaylist:
            return 1

        case .playlists:
            return playlistsList.value.count

        case .none:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .search:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseIdentifier, for: indexPath) as? SearchCell else {
                return .init()
            }
            cell.set(placeholder: "Find in playlists")
            return cell

        case .addPlaylist:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistsCell.reuseIdentifier, for: indexPath) as? PlaylistsCell else {
                return .init()
            }
            cell.setCreatePlaylist()
            return cell

        case .playlists:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistsCell.reuseIdentifier, for: indexPath) as? PlaylistsCell else {
                return .init()
            }
            cell.set(playlists: playlistsList.value[indexPath.row])
            return cell

        case .none:
            return .init()
        }
    }
}

extension PlaylistsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .search:
            break

        case .addPlaylist:
            Router.showCreatePlaylist()
            break

        case .playlists:
            Router.pushToDetail(playlists: playlistsList.value[indexPath.row])

        case .none:
            break
        }
    }
}

extension PlaylistsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch Section(rawValue: indexPath.section) {
        case .search:
            return .init(width: collectionView.bounds.size.width, height: SearchCell.cellHeight)

        case .addPlaylist, .playlists:
            return .init(width: collectionView.bounds.size.width, height: PlaylistsCell.cellHeight)

        case .none:
            return .zero
        }
    }
}
