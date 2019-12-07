//
//  Post.swift
//  JSONParsingTest
//
//  Created by Marcus Jensen on 14/10/2019.
//  Copyright © 2019 Marcus Jensen. All rights reserved.
//

import Foundation
struct Post: Codable{
    var strAlbum: String
    var strArtist: String
    var strAlbumThumb: String? = nil
    var idAlbum: String
    var intYearReleased: String
}
