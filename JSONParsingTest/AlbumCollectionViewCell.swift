//
//  AlbumCollectionViewCell.swift
//  JSONParsingTest
//
//  Created by Marcus Jensen on 18/10/2019.
//  Copyright © 2019 Marcus Jensen. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumThumb: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    
    override func awakeFromNib() {
        albumName.font = albumName.font.withSize(13)
        artistName.font = UIFont.boldSystemFont(ofSize: 18)
        /*self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowRadius = 0.5
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0*/
        self.layer.cornerRadius = 5.0
    }
}
