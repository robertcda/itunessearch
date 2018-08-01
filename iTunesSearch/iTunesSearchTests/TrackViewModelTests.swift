//
//  iTunesSearchTests.swift
//  iTunesSearchTests
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import XCTest
@testable import iTunesSearch

class TrackViewModelTests: XCTestCase {
    
    var trackViewModel: TrackViewModel?
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.trackViewModel = nil
        
        super.tearDown()
    }
    
    func testMainTableViewCellInterfaces() {
        let artName = "ArtistName"
        let trackName = "TrackName"
        let trackID: Int = 100
        let albumName = "AlbumName"

        let testDictionary:Track.TrackDictionary = ["artistName": artName,
                                                    "trackName":trackName,
                                                    "trackId":trackID,
                                                    "collectionName":albumName]
        let testTrack = Track(dictionary: testDictionary)
        self.trackViewModel = TrackViewModel(track: testTrack)
        
        XCTAssertEqual(trackName, self.trackViewModel?.firstRowValueLabel)
        XCTAssertEqual("Track:", self.trackViewModel?.firstRowLabelTitleLabel)
        XCTAssertEqual(artName, self.trackViewModel?.secondRowValueLabel)
        XCTAssertEqual("Artist:", self.trackViewModel?.secondRowTitleLabel)

    }
    
    func testDetailViewInterfaces(){
        let artName = "ArtistName"
        let trackName = "TrackName"
        let trackID: Int = 100
        let albumName = "AlbumName"
        
        let testDictionary:Track.TrackDictionary = ["artistName": artName,
                                                    "trackName":trackName,
                                                    "trackId":trackID,
                                                    "collectionName":albumName]
        let testTrack = Track(dictionary: testDictionary)
        self.trackViewModel = TrackViewModel(track: testTrack)
        
        XCTAssertEqual(trackName + "(" + artName + ")", self.trackViewModel?.detailTitleToDisplay)
        
        XCTAssertEqual("Not available", self.trackViewModel?.releaseDateToDisplay)

    }
    
}
