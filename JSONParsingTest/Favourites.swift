//
//  Favourites.swift
//  JSONParsingTest
//
//  Created by Marcus Jensen on 01/11/2019.
//  Copyright © 2019 Marcus Jensen. All rights reserved.
//

import Foundation

struct Favourites: Codable {
    let track: String
    let duration: String
    let artist: String
    let orderNumber: Int
    let trackId: String
}
