//
//  NetworkManager.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 19-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol NetworkManagerDelegate {
    func didSearchMusic(musicData: [Music])
    func didFailWithError(error: Error)
}

struct NetworkManager {
    let searchURL = "https://itunes.apple.com/search"
    let limit = 20
    let mediaType = "music"
    
    var delegate: NetworkManagerDelegate?
    
    func searchMusic(by term: String) {
        let safeTerm = term.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(searchURL)?mediaType=\(mediaType)&limit=\(limit)&term=\(safeTerm)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        AF.request(urlString).validate().responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                self.parseResponse(response: response)
            case let .failure(error):
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
    
    private func parseResponse(response: AFDataResponse<Any>) {
        var musicArray:[Music] = []
        
        let jsonData = JSON(response.value!)
        
        if let resultsArray = jsonData["results"].array {
            for item in resultsArray {
                let artistName = item["artistName"].stringValue
                let artworkUrl = item["artworkUrl100"].stringValue
                let thumbUrl = item["artworkUrl60"].stringValue
                let albumName = item["collectionName"].stringValue
                let albumUrl = item["collectionViewUrl"].stringValue
                let previewUrl = item["previewUrl"].stringValue
                
                let newMusic = Music(artist: artistName, artwork: artworkUrl, thumb: thumbUrl, album: albumName, url: albumUrl, preview: previewUrl)
                musicArray.append(newMusic)
            }
        } else {
            print(jsonData["results"].error!)
        }
        self.delegate?.didSearchMusic(musicData: musicArray)
    }
    
}

