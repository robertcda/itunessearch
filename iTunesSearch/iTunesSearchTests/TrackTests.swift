//
//  TrackTests.swift
//  iTunesSearchTests
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import XCTest
@testable import iTunesSearch

class TrackTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //Testing the succes case
    func testCreationFromDictionary() {
        let artName = "A"
        let trackName = "T"
        let trackID: Int = 100
        let albumName = "Ab"

        //TODO: ideally test all values both positive and negative.
        let testDictionary:Track.TrackDictionary = ["artistName": artName,
                                                    "trackName":trackName,
                                                    "trackId":trackID,
                                                    "collectionName":albumName]
        let testTrack = Track(dictionary: testDictionary)
        
        XCTAssertEqual(testTrack.artistName, artName)
        XCTAssertEqual(testTrack.trackName, trackName)
        XCTAssertEqual(testTrack.albumName, albumName)
        XCTAssertEqual(testTrack.trackId, trackID)

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    // Test the negative Case.
    func testCreationFromDictionaryInvalidInput(){
        let artName = 123
        let trackName = 456
        let trackID = ""
        let albumName = 123123
        
        let testDictionary:Track.TrackDictionary = ["artistName": artName,
                                                    "trackName":trackName,
                                                    "trackId":trackID,
                                                    "collectionName":albumName]
        let testTrack = Track(dictionary: testDictionary)
        
        XCTAssertNil(testTrack.artistName)
        XCTAssertNil(testTrack.trackName)
        XCTAssertNil(testTrack.trackId)
        XCTAssertNil(testTrack.albumName)
    }
    
    func testStringToDate() {
        XCTAssertNotNil("2014-12-09T08:00:00Z".dateFromTrackFormat())
        XCTAssertNotNil("2000-01-15T08:00:00Z".dateFromTrackFormat())
    }
    
}
