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
    var searchResults: [Song] = []
    var selectedSong: Song? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "resultCell")
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.musicData = selectedSong!
        }
    }
    
}

// MARK: - NetworkManagerDelegate Methods
extension ViewController: NetworkManagerDelegate {
    func didSearchMusic(musicData: [Song]) {
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
        
        cell.albumLabel.text = searchResults[indexPath.row].album?.name
        cell.artistLabel.text = searchResults[indexPath.row].artistName
        cell.thumbImageView.image = UIImage(data: searchResults[indexPath.row].album!.coverData!)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSong = searchResults[indexPath.row]
        
        performSegue(withIdentifier: "DetailSegue", sender: self)
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

