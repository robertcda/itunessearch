//
//  NetworkToModelInterpretor.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation
import UIKit

/**********
 A layer to interpret the JSON responses into the model objects.
 **********/
class NetworkToModelInterpretor{
    
    
    //MARK:- Errors
    enum ErrorNetworkToModelInterpretor:Error{
        case noDataReturnedWithNoError
    }
    
    typealias GetImageCompletion = (UIImage?,Error?) -> Void

    func getImage(urlPath:String, completion: @escaping GetImageCompletion){
        NetworkAPIManager().dataFrom(endPoint: NetworkAPIManager.Endpoint.imageFetch(urlPath: urlPath)) { (error, data) in
            var errorToReturn: Error? = error
            var image:UIImage? = nil
            
            guard errorToReturn == nil else{
                return
            }
            guard let dataObject = data else{
                
                return
            }
            image = UIImage(data: dataObject)
            
            defer{
                completion(image,errorToReturn)
            }
        }
    }
    
    /**********
     Use this to get the tracks from the server
     **********/
    typealias GetTracksCompletion = ([Track],Error?) -> Void

    func getTracks(searchText: String, completion:@escaping GetTracksCompletion){
        
        NetworkAPIManager().downloadJsonFrom(endPoint: .iTunesSearch(searchParameter: searchText)) { (error, dataObject) in
            var errorToReturn: Error? = nil
            var tracks:[Track] = []

            guard error == nil else{
                errorToReturn = error
                return
            }
            guard let dataObject = dataObject else{
                errorToReturn = ErrorNetworkToModelInterpretor.noDataReturnedWithNoError
                return
            }
            if let results = dataObject["results"] as? [Track.TrackDictionary]{
                for dict in results{
                    tracks.append(Track(dictionary: dict))
                }
            }
            defer{
                completion(tracks,errorToReturn)
            }

        }

    }
}
