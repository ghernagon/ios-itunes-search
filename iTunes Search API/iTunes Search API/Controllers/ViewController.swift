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
    let localDataManager = LocalDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.detailSegue {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SearchResultTableViewCell
        
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
        
        performSegue(withIdentifier: K.detailSegue, sender: self)
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        print(localDataManager.getSearchTerms())
        
//        if let historyData = LocalDataManager().getSearchData(forSearchTerm: "Farruko") {
//            searchResults = historyData
//            tableView.reloadData()
//        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            networkManager.searchMusic(by: searchTerm)
        }
//        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
    }
}

