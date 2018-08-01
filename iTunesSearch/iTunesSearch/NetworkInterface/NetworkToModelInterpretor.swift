//
//  NetworkToModelInterpretor.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation
import UIKit

protocol APIManagerInterface{
    typealias DataFromCompletionHandler = (Error?,Data?) -> Void
    func dataFrom(endPoint: Endpoint, completion:@escaping DataFromCompletionHandler)
    
    typealias APIResponseType = [String:Any]
    typealias DownloadJsonCompletionHandler = (Error?,APIResponseType?) -> Void
    func downloadJsonFrom(endPoint:Endpoint, completion:@escaping DownloadJsonCompletionHandler)
}

/**********
 A layer to interpret the JSON responses into the model objects.
 **********/
class NetworkToModelInterpretor{
    
    var apiManager:APIManagerInterface
    
    /**
     Introducitng the dependency Injection during initialization.
     */
    init(apiManager:APIManagerInterface = NetworkAPIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK:- Errors
    enum ErrorNetworkToModelInterpretor:Error{
        case noDataReturnedWithNoError, unableToConvertDataToImage, jsonDoenstContainResultsArray
    }
    
    typealias GetImageCompletion = (UIImage?,Error?) -> Void

    func getImage(urlPath:String, completion: @escaping GetImageCompletion){
        apiManager.dataFrom(endPoint: Endpoint.imageFetch(urlPath: urlPath)) { (error, data) in
            var errorToReturn: Error? = error
            var image:UIImage? = nil
            
            defer{
                completion(image,errorToReturn)
            }

            guard error == nil else{
                errorToReturn = error
                return
            }
            guard let dataObject = data else{
                errorToReturn = ErrorNetworkToModelInterpretor.noDataReturnedWithNoError
                return
            }
            
            guard let img = UIImage(data: dataObject) else{
                errorToReturn = ErrorNetworkToModelInterpretor.unableToConvertDataToImage
                return
            }
            
            // If i reached here then all should be good.
            image = img
            
        }
    }
    
    /**********
     Use this to get the tracks from the server
     **********/
    typealias GetTracksCompletion = ([Track],Error?) -> Void

    func getTracks(searchText: String, completion:@escaping GetTracksCompletion){
        
        apiManager.downloadJsonFrom(endPoint: .iTunesSearch(searchParameter: searchText)) { (error, dataObject) in
            var errorToReturn: Error? = nil
            var tracks:[Track] = []
            
            defer{
                completion(tracks,errorToReturn)
            }

            guard error == nil else{
                errorToReturn = error
                return
            }
            guard let dataObject = dataObject else{
                errorToReturn = ErrorNetworkToModelInterpretor.noDataReturnedWithNoError
                return
            }
            guard let resultsDictArray = dataObject["results"] as? [Track.TrackDictionary] else{
                errorToReturn = ErrorNetworkToModelInterpretor.jsonDoenstContainResultsArray
                return
            }
            
            // If i reach here, all should be good
            for dict in resultsDictArray{
                tracks.append(Track(dictionary: dict))
            }
        }
    }
}
