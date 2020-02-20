//
//  Music.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 19-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import Foundation

struct Music {
    var artistName: String
    var artworkUrl: String
    var thumbUrl: String
    var albumName: String
    var albumUrl: String
    var previewUrl: String
    
    init(artist artistName: String, artwork artworkUrl: String, thumb thumbUrl: String, album albumName: String, url albumUrl: String, preview previewUrl: String ) {
        self.artistName = artistName
        self.artworkUrl = artworkUrl
        self.thumbUrl = thumbUrl
        self.albumName = albumName
        self.albumUrl = albumUrl
        self.previewUrl = previewUrl
    }
}
