//
//  ViewModel.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation

class TrackViewModel{
    var track: Track
    init(track: Track) {
        self.track = track
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


extension TrackViewModel:DetailViewDataSource{
    
}
