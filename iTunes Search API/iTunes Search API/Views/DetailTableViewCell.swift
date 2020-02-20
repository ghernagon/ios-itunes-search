//
//  DetailTableViewCell.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 20-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var avControlButton: UIButton!
    
    var trackPreviewUrl: String? = nil
    var delegate: DetailTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        delegate?.didPressedAudioControl(cell: self, url: trackPreviewUrl!)
    }
}
