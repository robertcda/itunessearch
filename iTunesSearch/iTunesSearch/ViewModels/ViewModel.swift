//
//  ViewModel.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation
import UIKit

struct TrackViewModel{
    var track: Track
    private let modelInterpretor = NetworkToModelInterpretor()
    
    typealias ImageHandler = (UIImage)->Void
    
    init(track: Track) {
        self.track = track
    }
    
    /**********
     Fetches the thumbnail
     **********/
    func showThumbnailImage(thumbnailImageHandler:@escaping ImageHandler){
        
        //TODO: here we are taking always the 30 as the thumbnail, but what if for some reason the get fails or the resources is not existing, then i would like to retry with the 60 url and then 90 url, as a fallback.
        
        if let thumbnailPath = self.track.artworkUrl30{
            modelInterpretor.getImage(urlPath: thumbnailPath) { (image, error) in
                guard error == nil else{
                    print("TrackViewModel: Unable to fetch image: \(String(describing: error))")
                    return
                }
                guard let image = image else{
                    print("TrackViewModel: No Image returned.")
                    return
                }
                
                thumbnailImageHandler(image)
            }
        }
    }
    
    func fetchArtwork(thumbnailImageHandler:@escaping ImageHandler){
        if let thumbnailPath = self.track.artworkUrl100{
            modelInterpretor.getImage(urlPath: thumbnailPath) { (image, error) in
                guard error == nil else{
                    print("TrackViewModel:fetchArtwork: Unable to fetch image: \(String(describing: error))")
                    return
                }
                guard let image = image else{
                    print("TrackViewModel:fetchArtwork: No Image returned.")
                    return
                }
                
                thumbnailImageHandler(image)
            }
        }
    }
    
    
}

//**********************
//MARK:- MasterTableViewCellDataSource
//**********************

extension TrackViewModel:MasterTableViewCellDataSource{
    var imageViewState: MasterTableViewCell.ImageState {
        return .fetching
    }
    
    var firstRowLabelTitleLabel: String {
        return "Track:"
    }
    
    var firstRowValueLabel: String {
        return self.track.trackName ?? ""
    }
    
    var secondRowValueLabel: String {
        return self.track.artistName ?? ""
    }
    
    var secondRowTitleLabel: String {
        return "Artist:"
    }
}

//**********************
//MARK:- DetailView interface methods.
//**********************

//TODO: make a protocol for this DetailView.
extension TrackViewModel{
    var priceToDisplay: String{
        var displayPrice = "Not Available"

        guard let currency = self.track.currency else{
            return displayPrice
        }
        guard let priceInt = self.track.price else{
            return displayPrice
        }

        displayPrice = String(priceInt) + " " + currency
        
        return displayPrice
    }
    
    var releaseDateToDisplay: String{
        if let releaseDate = self.track.releaseDate{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-mm-YYYY"
            
            return dateFormatter.string(from: releaseDate)
        }
        return "Not available"
    }
    
    var detailTitleToDisplay: String{
        var displayTitle = ""
        
        guard let name = self.track.trackName else{
            return displayTitle
        }
        guard let artist = self.track.artistName else{
            return displayTitle
        }
        displayTitle = name + "(" + artist + ")"
        return displayTitle
    }
}
