//
//  Song.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 19-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import Foundation

struct Song {
    var trackName: String?
    var artistId: Int?
    var artistName: String?
    var artworkUrl: String?
    var thumbUrl: String?
    var previewUrl: String?
    var album: Album?
    
//    init(artist artistName: String, artwork artworkUrl: String, artworkData: NSData, thumbUrl: String, album albumName: String, url albumUrl: String, preview previewUrl: String, albumId: Int, artistId: Int ) {
//        self.artistName = artistName
//        self.artworkUrl = artworkUrl
//        self.thumbUrl = thumbUrl
//        self.previewUrl = previewUrl
//        self.artistId = artistId
//
//        self.album = Album(name: albumName, id: albumId, coverUrl: artworkUrl, coverData: artworkData, artistId: artistId, artistName: artistName)
//    }
}
