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
    
    let trackId: Int?
    
    let artistName: String?
    
    let trackName: String?
    
    let albumName: String?
    let price: Double?
    let releaseDate: Date?
    
    let artworkUrl30: String?
    let artworkUrl60: String?
    let artworkUrl100: String?

    init(dictionary:TrackDictionary) {
        self.artistName = dictionary["artistName"] as? String
        self.trackName = dictionary["trackName",default: ""] as? String
        self.trackId = dictionary["trackId",default: ""] as? Int
        
        self.albumName = dictionary["collectionName",default: ""] as? String
        self.price = dictionary["trackPrice",default: ""] as? Double
        if let dateString = dictionary["releaseDate",default: ""] as? String{
            self.releaseDate = dateString.dateFromTrackFormat()
        }else{
            self.releaseDate = nil
        }

        
        self.artworkUrl30 = dictionary["artworkUrl30",default: ""] as? String
        self.artworkUrl60 = dictionary["artworkUrl60",default: ""] as? String
        self.artworkUrl100 = dictionary["artworkUrl100",default: ""] as? String
    }
}


extension String{
    func dateFromTrackFormat() -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: self)
        return date
    }
}
