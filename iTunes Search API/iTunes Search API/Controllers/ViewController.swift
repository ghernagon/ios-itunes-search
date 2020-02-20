//
//  ViewController.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 19-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var networkManager = NetworkManager()
    
    var searchResults: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        tableView.dataSource = self
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        networkManager.searchMusic(by: "a9s8dy7a8bsdad8989 asd7889as7d")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! SearchResultTableViewCell
        
        cell.textLabel?.text = searchResults[indexPath.row].albumName
        
        return cell
    }
}

