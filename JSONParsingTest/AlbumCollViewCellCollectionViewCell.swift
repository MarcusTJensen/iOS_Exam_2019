//
//  AlbumCollViewCellCollectionViewCell.swift
//  JSONParsingTest
//
//  Created by Marcus Jensen on 17/10/2019.
//  Copyright © 2019 Marcus Jensen. All rights reserved.
//

import UIKit

class AlbumCollViewCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumThumbnail: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        artistName.accessibilityIdentifier = "artistColl"
        artistName.font = UIFont.boldSystemFont(ofSize: 20)
        albumName.font = albumName.font.withSize(15)
    }
    
    /*func setupViews() {
        artistName.text = "zup"
        artistName.font = UIFont.boldSystemFont(ofSize: 20)
        albumName.font = albumName.font.withSize(15)
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
