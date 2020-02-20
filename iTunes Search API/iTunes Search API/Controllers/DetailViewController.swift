//
//  DetailViewController.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 20-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var musicData: Song? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "detailCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let data = musicData {
            albumLabel.text = data.album?.name
            artistLabel.text = data.artistName
            albumImage.image = UIImage(data: data.album!.coverData!)
        }
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicData?.album?.tracks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell
        cell.artistNameLabel.text = musicData?.album?.tracks![indexPath.row].artistName
        cell.trackNameLabel.text = musicData?.album?.tracks![indexPath.row].trackName
        
        return cell
    }
    
    
}
