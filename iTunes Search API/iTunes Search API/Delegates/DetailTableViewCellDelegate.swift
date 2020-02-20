//
//  DetailTableViewCellDelegate.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 20-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import Foundation

protocol DetailTableViewCellDelegate {
    func didPressedAudioControl(cell: DetailTableViewCell, url: String)
}
