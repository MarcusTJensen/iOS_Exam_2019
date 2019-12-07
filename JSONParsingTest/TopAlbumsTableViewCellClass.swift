//
//  TopAlbumsTableViewCellClassTableViewCell.swift
//  JSONParsingTest
//
//  Created by Marcus Jensen on 05/12/2019.
//  Copyright © 2019 Marcus Jensen. All rights reserved.
//

import UIKit

class TopAlbumsTableViewCellClass: UITableViewCell {
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet weak var albumName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        artistName.font = UIFont.boldSystemFont(ofSize: 20)
        albumName.font = albumName.font.withSize(15)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
