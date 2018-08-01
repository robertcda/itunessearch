//
//  NetworkToModelInterpretor.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation

class NetworkToModelInterpretor{
    
    typealias GetTracksCompletion = ([Track],Error?) -> Void
    
    //MARK:- Errors
    enum ErrorNetworkToModelInterpretor:Error{
        case noDataReturnedWithNoError
    }
    
    /**********
     todo//TODO: Write commment
     **********/
    func getTracks(searchText: String, completion:@escaping GetTracksCompletion){
        var tracks:[Track] = []
        
        NetworkAPIManager().getdata(endPoint: .iTunesSearch(searchParameter: searchText)) { (error, dataObject) in
            guard error == nil else{
                completion(tracks,error)
                return
            }
            guard let dataObject = dataObject else{
                completion(tracks,ErrorNetworkToModelInterpretor.noDataReturnedWithNoError)
                return
            }
            if let results = dataObject["results"] as? [Track.TrackDictionary]{
                for dict in results{
                    tracks.append(Track(dictionary: dict))
                }
                completion(tracks,error)
            }
        }

    }
}
