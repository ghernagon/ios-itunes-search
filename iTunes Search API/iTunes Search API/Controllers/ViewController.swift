//
//  ViewController.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 19-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var networkManager = NetworkManager()
    
    var searchResults: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "resultCell")
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
    }
    
}

// MARK: - NetworkManagerDelegate Methods
extension ViewController: NetworkManagerDelegate {
    func didSearchMusic(musicData: [Music]) {
        searchResults = musicData
        tableView.reloadData()
    }
    
    func didFailWithError(error: Error) {
        print("OCURRIO UN ERROR", error.localizedDescription)
    }
}

// MARK: - UITableView DataSource
extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! SearchResultTableViewCell
        
        cell.albumLabel.text = searchResults[indexPath.row].albumName
        cell.artistLabel.text = searchResults[indexPath.row].artistName
        cell.thumbImageView.af_setImage(withURL: URL(string: searchResults[indexPath.row].thumbUrl)!)
        
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            networkManager.searchMusic(by: searchTerm)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

