//
//  RecommendedCell.swift
//  JSONParsingTest
//
//  Created by Marcus Jensen on 02/12/2019.
//  Copyright © 2019 Marcus Jensen. All rights reserved.
//

import UIKit

class RecommendedCell: UICollectionViewCell {
    
    @IBOutlet weak var artistName: UILabel!
    
    override func awakeFromNib() {
        artistName.font = artistName.font.withSize(15)
        
    }
}
