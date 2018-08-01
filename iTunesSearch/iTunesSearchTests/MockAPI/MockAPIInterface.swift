//
//  MockAPIInterface.swift
//  iTunesSearchTests
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import XCTest
@testable import iTunesSearch

/**********
 Use this to simulate network calls. This is the bare minimun.
 **********/
class MockAPIInterface{
    let dataFrom: Data?
    let jsonResponseObject: APIManagerInterface.APIResponseType?
    let error: Error?
    
    init(error:Error? = nil, dataFrom: Data? = nil, jsonResponseObject: APIManagerInterface.APIResponseType? = nil) {
        self.dataFrom = dataFrom
        self.jsonResponseObject = jsonResponseObject
        self.error = error
    }
}

extension MockAPIInterface:APIManagerInterface{
    /**********
     For the apis we are trying to mock simply go background and wait and call completion with the data we initialized with.
     **********/
    func dataFrom(endPoint: Endpoint, completion: @escaping APIManagerInterface.DataFromCompletionHandler) {
        DispatchQueue.global().async {
            sleep(2)
            completion(self.error,self.dataFrom)
        }
    }
    
    func downloadJsonFrom(endPoint: Endpoint, completion: @escaping APIManagerInterface.DownloadJsonCompletionHandler) {
        DispatchQueue.global().async {
            sleep(2)
            completion(self.error, self.jsonResponseObject)
        }
    }
}
