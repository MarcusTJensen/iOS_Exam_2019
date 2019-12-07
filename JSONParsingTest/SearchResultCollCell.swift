//
//  SearchResultCollCell.swift
//  JSONParsingTest
//
//  Created by Marcus Jensen on 01/11/2019.
//  Copyright © 2019 Marcus Jensen. All rights reserved.
//

import UIKit

class SearchResultCollCell: UICollectionViewCell {
    
    @IBOutlet weak var albumThumb: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    
    override func awakeFromNib() {
        artistName.font = artistName.font.withSize(10)
        albumName.font = UIFont.boldSystemFont(ofSize: 14)
        self.layer.cornerRadius = 5.0
    }
    
}
