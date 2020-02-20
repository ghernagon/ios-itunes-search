//
//  Album.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 20-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import Foundation

struct Album {
    var name: String?
    var id: Int?
    var coverUrl: String?
    var coverData: Data?
    var artistId: Int?
    var artistName: String?
    var tracks: [Song]?
}
