//
//  Track.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation

//protocol TrackValues{
//}
//extension Int:TrackValues{}
//extension String:TrackValues{}
//extension Bool:TrackValues{}
//extension Float:TrackValues{}
//extension Date:TrackValues{}

struct Track {
    typealias TrackDictionary = [String:Any]
    
    let artistName: String?
    let trackName: String?
    let trackId: Int?
    let artworkUrl30: String?
    let artworkUrl60: String?
    let artworkUrl100: String?

    init(dictionary:TrackDictionary) {
        self.artistName = dictionary["artistName"] as? String
        self.trackName = dictionary["trackName",default: ""] as? String
        self.trackId = dictionary["trackId",default: ""] as? Int
        self.artworkUrl30 = dictionary["artworkUrl30",default: ""] as? String
        self.artworkUrl60 = dictionary["artworkUrl60",default: ""] as? String
        self.artworkUrl100 = dictionary["artworkUrl100",default: ""] as? String
    }
}
