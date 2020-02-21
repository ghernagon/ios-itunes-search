//
//  Album.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 20-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import Foundation

struct Album: Codable {
    var name: String?
    var id: Int?
    var coverUrl: String?
    var coverData: Data?
    var artistId: Int?
    var artistName: String?
    var tracks: [Song]?
    
//    public init(from decoder: Decoder) throws {
//        var container = try decoder.unkeyedContainer()
//        self.name = try container.decode(String.self)
//        self.id = try container.decode(Int.self)
//        self.coverUrl = try container.decode(String.self)
//        self.coverData = try container.decode(Data.self)
//        self.artistId = try container.decode(Int.self)
//        self.artistName = try container.decode(String.self)
//        self.tracks = try container.decode([Song].self)
//    }
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.unkeyedContainer()
//        try container.encode(name)
//        try container.encode(id)
//        try container.encode(coverUrl)
//        try container.encode(coverData)
//        try container.encode(artistId)
//        try container.encode(artistName)
//        try container.encode(tracks)
//    }
}
