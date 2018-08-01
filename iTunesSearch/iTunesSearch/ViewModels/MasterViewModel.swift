//
//  MasterViewModel.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation
class MasterViewModel{
    
    /**********
     A view model for each track
     **********/
    public var models:[TrackViewModel] = []
    
    /**********
     a model interpretor which the View Model can interface to better interpret the model.
     **********/
    private let modelInterpretor = NetworkToModelInterpretor()

    /**********
     //TODO: would have ideally designed a queue and when a new request is recieved to destroy the previous requests. But that would take some more time. For now, using a very simple logic by maintaining the latest searchText.
     **********/
    private var searchTextRequest: String = ""
    
    
    /**********
     Thie handler will be called whenever there is an update in the search results.
     So update your UI in this block from Controller.
     **********/
    public var searchResultsUpdatedHandler:SearchResultsUpdatedhandler?
    typealias SearchResultsUpdatedhandler = () -> Void

    /**********
     Just tells the View Model that the user has made request for search.
     This method will ensure that only the latest results will be passed back by calling the appropriate block(searchResultsUpdatedHandler).
     **********/
    func searchFor(searchText:String){
        
        // First store the latest search string into an instance variable.
        self.searchTextRequest = searchText
        
        //Make the network call.
        modelInterpretor.getTracks(searchText: searchText) { (tracks, error) in
            
            // On getting the results, check if the result we got is for the latest request that we sent
            guard self.searchTextRequest == searchText else{
                // If it was for an earlier request, we are not interested in the response.
                print("MasterViewModel:searchFor: Old request thus discarding...: searchText:\(searchText)")
                return
            }
            
            print("MasterViewModel:searchFor: ResponseFor:searchText:\(searchText), Tracks:\(tracks.count)")
            
            // TODO: if i had more time, instead of discarding the view models, we can update the existing view models with the model objects. But here time is of essence.
            self.models.removeAll()
            self.models.append(contentsOf: tracks.map({ TrackViewModel(track: $0)}))
            
            DispatchQueue.main.async {
                self.searchResultsUpdatedHandler?()
            }
        }
    }
}
