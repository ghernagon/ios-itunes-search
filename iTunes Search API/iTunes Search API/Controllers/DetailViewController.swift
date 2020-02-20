//
//  DetailViewController.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 20-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import UIKit
import AlamofireImage
import AVFoundation


class DetailViewController: UIViewController {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var musicData: Song? = nil
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var currentCell: DetailTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.Detail.cellNibName, bundle: nil), forCellReuseIdentifier: K.Detail.cellIdentifier)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Detail.cellIdentifier, for: indexPath) as! DetailTableViewCell
        cell.delegate = self
        cell.artistNameLabel.text = musicData?.album?.tracks![indexPath.row].artistName
        cell.trackNameLabel.text = musicData?.album?.tracks![indexPath.row].trackName
        cell.trackPreviewUrl = musicData?.album?.tracks![indexPath.row].previewUrl
        return cell
    }
}

// MARK: - DetailTableViewCellDelegate
extension DetailViewController: DetailTableViewCellDelegate {
    
    func didPressedAudioControl(cell: DetailTableViewCell, url: String) {
        
        if currentCell == nil { currentCell = cell }
        
        if currentCell == cell {

            if player?.rate == nil {
                let url = URL(string: url)
                playerItem = AVPlayerItem(url: url!)
                player = AVPlayer(playerItem: playerItem)
                player!.play()
                cell.avControlButton.setImage(UIImage(systemName: K.Detail.pauseIcon), for: .normal)
            } else if player?.rate == 0 {
                player!.play()
                cell.avControlButton.setImage(UIImage(systemName: K.Detail.pauseIcon), for: .normal)
            } else {
                player?.pause()
                cell.avControlButton.setImage(UIImage(systemName: K.Detail.playIcon), for: .normal)
            }
            
        } else {
            currentCell!.avControlButton.setImage(UIImage(systemName: K.Detail.playIcon), for: .normal)
            let url = URL(string: url)
            playerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            player!.play()
            cell.avControlButton.setImage(UIImage(systemName: K.Detail.pauseIcon), for: .normal)
            currentCell = cell
        }
        
    }
}
