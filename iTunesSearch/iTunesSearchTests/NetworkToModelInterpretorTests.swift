//
//  NetworkToModelInterpretorTests.swift
//  iTunesSearchTests
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import XCTest
@testable import iTunesSearch

class NetworkToModelInterpretorTests: XCTestCase {
    
    var objectUnderTest:NetworkToModelInterpretor!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        self.objectUnderTest = nil
        super.tearDown()
    }
    
    /*
     Here checking if the correct error is recieved if the server sends data that cannot be converted to an UIImage.
     */
    func testGetImage() {
        // Here i am providing a mock API Interface and set what i want to be returned by the Mock API.
        let someUnconvertableData = Data()
        self.objectUnderTest = NetworkToModelInterpretor(apiManager: MockAPIInterface(error: nil,
                                                                                      dataFrom: someUnconvertableData ))
        
        // Set the expection and execute the API.
        let expect = expectation(description: "getImage Fail Case")
        self.objectUnderTest.getImage(urlPath: "") { (image, error) in
            XCTAssertNil(image)
            XCTAssertNotNil(error)
            if let error = error{
                switch error{
                case NetworkToModelInterpretor.ErrorNetworkToModelInterpretor.unableToConvertDataToImage:
                    XCTAssert(true, "Recieved Correct error")
                default:
                    XCTAssert(false, "Recieved an incorrect error.")
                }
            }
            
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 10)
    }
    
    //TODO: getImage api more tests can be added to validate by Mocking any error or sending a correct image.
    
    
    func testGetTracks(){
        // Here i am providing a mock API Interface.
        var tracksArray:[[String:Any]] = []
        tracksArray.append(["trackId":123,
                            "artistName":"Adele",
                            "collectionName":"Collection"])
        let mockJSONResponse:[String:Any] = ["resultCount":10,
                                             "results":tracksArray]
        
        let someUnconvertableData = Data()
        self.objectUnderTest = NetworkToModelInterpretor(apiManager: MockAPIInterface(error: nil, jsonResponseObject: mockJSONResponse ))
        
        let getTrackExpection = expectation(description: "getting Tracks")
        self.objectUnderTest.getTracks(searchText: "doens't matter") { (tracks, error) in
            XCTAssert(tracks.count == 1, "Tracks are not getting created")
            if let track = tracks.first{
                XCTAssert(track.trackId == 123, "trackID initialization is incorrect.")
                XCTAssert(track.artistName == "Adele", "artistname initialization is incorrect.")
                XCTAssert(track.albumName == "Collection", "Collection initialization is incorrect.")
            }
            getTrackExpection.fulfill()
        }
        
        wait(for: [getTrackExpection], timeout: 10)
    }

    
}
