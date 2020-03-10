//
//  PlaylistsDetailViewController.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/03/09.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import Entity
import ReactiveCocoa
import ReactiveSwift
import Repository
import UIKit

class PlaylistsDetailViewController: UIViewController {
    private enum Section: Int, CaseIterable {
        case search
        case header
        case download
        case track
    }

    private let playlists: Playlists
    // TODO: Playlistsに持たせてキャッシュしたい
    private let tracks: MutableProperty<[Track]> = .init([])

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
        collectionView.register(PlaylistsDetailHeaderCell.self, forCellWithReuseIdentifier: PlaylistsDetailHeaderCell.reuseIdentifier)
        collectionView.register(PlaylistsDetailDownloadCell.self, forCellWithReuseIdentifier: PlaylistsDetailDownloadCell.reuseIdentifier)
        collectionView.register(PlaylistsTrackCell.self, forCellWithReuseIdentifier: PlaylistsTrackCell.reuseIdentifier)

        return collectionView
    }()

    init(playlists: Playlists) {
        self.playlists = playlists
        
        super.init(nibName: nil, bundle: nil)

        tracks <~ Repository.shared.getPlaylistsTracks(playlistsId: playlists.id)
            .flatMapError { _ in .init(value: []) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

private extension PlaylistsDetailViewController {
    func configure() {
        view.backgroundColor = SpotifyColor.black
        view.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.reactive.reloadData <~ tracks.map { _ in }

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func showActionSheet(for track: Track, at position: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteTrack = UIAlertAction(title: "このプレイリストから削除", style: .destructive) { [weak self] _ in
            let alert = UIAlertController(title: "曲の削除", message: "「\(track.name)」をこのプレイリストから削除します。よろしいですか？", preferredStyle: .alert)
            let delete = UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
                self?.remove(track: track, at: position)
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            alert.addAction(delete)
            alert.addAction(cancel)
            self?.present(alert, animated: true)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        actionSheet.addAction(deleteTrack)
        actionSheet.addAction(cancel)
        // TODO: Routerに移した方がいいかも
        present(actionSheet, animated: true)
    }

    func remove(track: Track, at position: Int) {
        Repository.shared.removeTrack(playlistsId: playlists.id, trackUri: track.uri, position: position)
            .observe(on: UIScheduler())
            .startWithResult { [weak self] result in
                switch result {
                case .success:
                    // TODO: playlistsのsnapshotIdを更新したい
                    self?.tracks.value.remove(at: position)

                case .failure(let error):
                    print(error.localizedDescription)
                    Router.showError(message: "曲の削除に失敗しました")
                }
        }
    }
}

extension PlaylistsDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .search:
            return 1

        case .header:
            return 1

        case .download:
            return 1

        case .track:
            return tracks.value.count

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
            cell.set(placeholder: "Find in liked songs")
            return cell

        case .header:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistsDetailHeaderCell.reuseIdentifier, for: indexPath) as? PlaylistsDetailHeaderCell else {
                return .init()
            }
            cell.set(playlistsName: playlists.name)
            return cell

        case .download:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistsDetailDownloadCell.reuseIdentifier, for: indexPath) as? PlaylistsDetailDownloadCell else {
                return .init()
            }
            return cell

        case .track:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistsTrackCell.reuseIdentifier, for: indexPath) as? PlaylistsTrackCell else {
                return .init()
            }
            let track = tracks.value[indexPath.row]
            cell.set(track: track) { [weak self] in
                self?.showActionSheet(for: track, at: indexPath.row)
            }
            return cell

        case .none:
            return .init()
        }
    }
}

extension PlaylistsDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch Section(rawValue: indexPath.section) {
        case .search:
            return .init(width: collectionView.bounds.size.width, height: SearchCell.cellHeight)

        case .header:
            return .init(width: collectionView.bounds.size.width, height: PlaylistsDetailHeaderCell.cellHeight)

        case .download:
            return .init(width: collectionView.bounds.size.width, height: PlaylistsDetailDownloadCell.cellHeight)

        case .track:
            return .init(width: collectionView.bounds.size.width, height: PlaylistsTrackCell.cellHeight)

        case .none:
            return .zero
        }
    }
}
