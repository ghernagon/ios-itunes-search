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
    var shouldShowPreviousSearch: Bool = true
    var previousSearchTerms: [String] = []
    
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
        shouldShowPreviousSearch = false
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
        var numberOfRows = 0
        
        if shouldShowPreviousSearch {
            numberOfRows = previousSearchTerms.count
        } else {
            numberOfRows = searchResults.count
        }
        
        return numberOfRows
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if shouldShowPreviousSearch {
            let historyCell = UITableViewCell()
            historyCell.textLabel?.text = previousSearchTerms[indexPath.row]
            cell = historyCell
        } else {
            let searchCell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SearchResultTableViewCell
            searchCell.albumLabel.text = searchResults[indexPath.row].album?.name
            searchCell.artistLabel.text = searchResults[indexPath.row].artistName
            searchCell.thumbImageView.image = UIImage(data: searchResults[indexPath.row].album!.coverData!)
            cell = searchCell
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldShowPreviousSearch {
            searchResults = localDataManager.getSearchData(forSearchTerm: previousSearchTerms[indexPath.row])!
            shouldShowPreviousSearch = false
            tableView.reloadData()
        } else {
            selectedSong = searchResults[indexPath.row]
            performSegue(withIdentifier: K.detailSegue, sender: self)
        }
        searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.moveUpAndFade(rowHeight: cell.frame.height, duration: 0.5, delay: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
            shouldShowPreviousSearch = true
            previousSearchTerms = localDataManager.getSearchTerms()!
            tableView.reloadData()
            title = K.previousSearchTitle
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text!
        if !searchTerm.isEmpty {
            networkManager.searchMusic(by: searchTerm)
            title = searchTerm
        }
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
