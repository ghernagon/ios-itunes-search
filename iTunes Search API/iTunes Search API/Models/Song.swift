//
//  Song.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 19-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import Foundation

struct Song: Codable {
    var trackName: String?
    var artistId: Int?
    var artistName: String?
    var artworkUrl: String?
    var thumbUrl: String?
    var previewUrl: String?
    var album: Album?
}
