//
//  K.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 20-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import Foundation

struct K {
    static let cellIdentifier = "resultCell"
    static let cellNibName = "SearchResultTableViewCell"
    static let detailSegue = "DetailSegue"
    
    struct Detail {
        static let cellIdentifier = "detailCell"
        static let cellNibName = "DetailTableViewCell"
        static let pauseIcon = "pause.fill"
        static let playIcon = "play.fill"
    }
}
