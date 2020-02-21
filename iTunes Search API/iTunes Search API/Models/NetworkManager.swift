//
//  NetworkManager.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 19-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

struct NetworkManager {
    let searchURL = "https://itunes.apple.com/search"
    let lookupURL = "https://itunes.apple.com/lookup"
    let limit = 20
    let mediaType = "music"
    let entity = "song"
    
    var currentSearchTerm: String = ""
    var delegate: NetworkManagerDelegate?
    let localDataManager = LocalDataManager()
    
    // It form the URL based on search term
    mutating func searchMusic(by term: String) {
        currentSearchTerm = term
        let safeTerm = term.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(searchURL)?entity=\(entity)&limit=\(limit)&term=\(safeTerm)"
        performRequest(with: urlString)
    }
    
    // Perform search music request
    private func performRequest(with urlString: String) {
        AF.request(urlString).validate().responseJSON { response in
            switch response.result {
            case .success:
                self.parseResponse(response: response)
            case let .failure(error):
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
    
    // Parse the search response
    private func parseResponse(response: AFDataResponse<Any>) {
        let requestGroup = DispatchGroup()
        let parseGroup = DispatchGroup()
        
        var musicArray:[Song] = []
        let jsonData = JSON(response.value!)

        if let songsArray = jsonData["results"].array {
            for item in songsArray {
                parseGroup.enter()

                let trackName = item["trackName"].stringValue
                let artistName = item["artistName"].stringValue
                let artistId = item["artistId"].intValue
                let artworkUrl = item["artworkUrl100"].stringValue
                let thumbUrl = item["artworkUrl60"].stringValue
                let albumName = item["collectionName"].stringValue
                let previewUrl = item["previewUrl"].stringValue
                let albumId = item["collectionId"].intValue
                
                var newTrack = Song()
                newTrack.trackName = trackName
                newTrack.artistName = artistName
                newTrack.artistId = artistId
                newTrack.artworkUrl = artworkUrl
                newTrack.thumbUrl = thumbUrl
                newTrack.previewUrl = previewUrl
                
                var newAlbum = Album()
                newAlbum.artistId = artistId
                newAlbum.artistName = artistName
                newAlbum.coverUrl = artworkUrl
                newAlbum.coverData = nil
                newAlbum.id = albumId
                newAlbum.name = albumName
                newAlbum.tracks = [Song]()
                
                // Download cover image
                requestGroup.enter()
                AF.request(newAlbum.coverUrl!).responseImage { (response) in
                    if let imageData = response.value?.jpegData(compressionQuality: 100.0) {
                        newAlbum.coverData = imageData
                    }
                    requestGroup.leave()
                }
                
                // Get album track list
                requestGroup.enter()
                let urlString = "\(lookupURL)?entity=\(entity)&id=\(albumId)"
                AF.request(urlString).validate().responseJSON { response in
                    switch response.result {
                    case .success:
                        let jsonTracksData = JSON(response.value!)
                        if let responseArray = jsonTracksData["results"].array {
                            for track in responseArray {
                                guard track["wrapperType"] == "track" else { continue }
                                var newSong = Song()
                                newSong.artistId = track["artistId"].intValue
                                newSong.artistName = track["artistName"].stringValue
                                newSong.previewUrl = track["previewUrl"].stringValue
                                newSong.artworkUrl = track["artworkUrl100"].stringValue
                                newSong.thumbUrl = track["artworkUrl60"].stringValue
                                newSong.trackName = track["trackName"].stringValue

                                newAlbum.tracks?.append(newSong)
                            }
                        }
                    case let .failure(error):
                        self.delegate?.didFailWithError(error: error)
                    }

                    requestGroup.leave()
                }

                requestGroup.notify(queue: .main) {
                    newTrack.album = newAlbum
                    musicArray.append(newTrack)
                    parseGroup.leave()
                }
            }
        } else {
            print(jsonData["results"].error!)
        }
        
        parseGroup.notify(queue: .main) {
            self.delegate?.didSearchMusic(musicData: musicArray)
            
            // Save the searh term and response data
            self.localDataManager.storeTerm(self.currentSearchTerm)
            self.localDataManager.storeSearchData(forSearchTerm: self.currentSearchTerm, data: musicArray)
        }
    }
}

