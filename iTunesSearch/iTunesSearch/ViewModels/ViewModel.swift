//
//  ViewModel.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation
import UIKit

class TrackViewModel{
    var track: Track
    
    typealias ImageHandler = (UIImage)->Void
    var thumbnailImageHandler:ImageHandler?
    
    init(track: Track) {
        self.track = track
    }
    
    func showThumbnailImage(){
        if let thumbnailPath = self.track.artworkUrl30{
            NetworkToModelInterpretor().getImage(urlPath: thumbnailPath) { (image, error) in
                guard error == nil else{
                    print("TrackViewModel: Unable to fetch image")
                    return
                }
                guard let image = image else{
                    print("TrackViewModel: No Image returned.")
                    return
                }
                
                self.thumbnailImageHandler?(image)

            }

        }
    }
}

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
