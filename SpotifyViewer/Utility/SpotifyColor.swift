//
//  SpotifyColor.swift
//  SpotifyViewer
//
//  Created by shiba on 2020/03/04.
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//

import UIKit

enum SpotifyColor {
    static let green: UIColor = .init(hex: 0x1DB954)
    static let black: UIColor = .init(hex: 0x191414)
    static let gray: UIColor = .init(hex: 0x252525)
    static let lightGray: UIColor = .init(hex: 0xAAAAAA)
}

private extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255
        let blue = CGFloat((hex & 0x0000FF) >> 0) / 255

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

