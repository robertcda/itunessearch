//
//  NetworkAPIManager.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation



class NetworkAPIManager {
    
    enum Endpoint{
        case iTunesSearch(searchParameter:String)
        
        var url: URL?{
            switch self {
            case .iTunesSearch(let searchParameter):
                return URL(string: "https://itunes.apple.com/search?term=\(searchParameter.replaceSpaceWithAPlus)")
            }
        }
    }
    
    /**********
     https://itunes.apple.com/search?term=SEARCHTERM1+SEARCHTERM2
     **********/
    
    typealias APIResponseType = [String:Any]
    typealias CompletionHandler = (Error?,APIResponseType?) -> Void
    
    func getdata(endPoint:Endpoint, completion:@escaping CompletionHandler) {
        let urlSession = URLSession(configuration: .default)
        if let url = endPoint.url{
            print("url:\(url)")
            let downloadTask = urlSession.downloadTask(with: url) { (url, urlResponse, error) in
                guard error == nil else{
                    print("Error: \(error)")
                    return
                }
                if let url = url{
                    print("Downloaded file available at \(url)")
                    if let data = try? Data(contentsOf: url){
                        do{
                            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            if let jsonObjectDictionary = jsonObject as? [String:Any]{
                                print("\(jsonObjectDictionary.count)")
                                completion(nil,jsonObjectDictionary)
                            }
                            print("jsonObject: \(jsonObject)")
                            
                        }catch let e{
                            print("JSON Serialization Failed: \(e)")
                        }
                    }else{
                        print("Error converting file to Data")
                    }
                    
                }
            }
            downloadTask.resume()
            
        }
        
    }
}
