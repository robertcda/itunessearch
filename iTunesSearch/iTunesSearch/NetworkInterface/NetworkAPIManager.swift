//
//  NetworkAPIManager.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation


/**********
 All network calls routed through this guy.
 **********/
class NetworkAPIManager {
    
    let defaultSession = URLSession(configuration: .default)
    
    
    //MARK:- EndPoints
    enum Endpoint{
        case iTunesSearch(searchParameter:String)
        case imageFetch(urlPath:String)
        var url: URL?{
            switch self {
            case .iTunesSearch(let searchParameter):
                return URL(string: "https://itunes.apple.com/search?term=\(searchParameter.replaceSpaceWithAPlus)")
            case .imageFetch(let urlPath):
                return URL(string: urlPath)
            }
        }
    }
    
    //MARK:- Errors
    enum ErrorsNetworkAPIManager: Error{
        case jsonSerializationFailed, unableToReadContentsOfURL
    }
    
    //MARK:- Network Calls
    
    
    
    //**********************
    //MARK:- GetImage
    //**********************
    typealias DataFromCompletionHandler = (Error?,Data?) -> Void

    func dataFrom(endPoint:Endpoint, completion:@escaping DataFromCompletionHandler){
        DispatchQueue.global().async {
            if let url = endPoint.url{
                print("url:\(url)")
                let dataTask = self.defaultSession.dataTask(with: url) { (data, urlresponse, error) in
                    // First establish the return value
                    var errorToReturn = error
                    var dataObject:Data? = data
                    
                    guard errorToReturn == nil else{
                        print("NetworkAPIManager:dataFrom: Error: \(String(describing: error))")
                        return
                    }
                    
                    /**********
                     Note: sometimes due to many conditional checks we may miss to call completion which may lead to someone waiting infitintly, but by using Defer, we ensure that no matter what the completion is called at a relatively smaller cost.
                     **********/
                    defer{
                        completion(errorToReturn,dataObject)
                    }
                }
                dataTask.resume()
            }
        }
    }
    
    
    /**********
     GetData: used to establish a download task for a particular endpoint.
     **********/
    typealias APIResponseType = [String:Any]
    typealias DownloadJsonCompletionHandler = (Error?,APIResponseType?) -> Void
    
    func downloadJsonFrom(endPoint:Endpoint, completion:@escaping DownloadJsonCompletionHandler) {
        DispatchQueue.global().async {
            if let url = endPoint.url{
                let downloadTask = self.defaultSession.downloadTask(with: url) { (url, urlResponse, error) in
                    
                    // First establish the return value
                    var errorToReturn = error
                    var dataObject:[String:Any]? = nil
                    
                    guard errorToReturn == nil else{
                        print("NetworkAPIManager:getData: Error: \(String(describing: error))")
                        return
                    }
                    
                    if let url = url{
                        if let data = try? Data(contentsOf: url){
                            do{
                                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                                if let jsonObjectDictionary = jsonObject as? [String:Any]{
                                    dataObject = jsonObjectDictionary
                                }
                                
                            }catch let e{
                                print("NetworkAPIManager:getData: during JSON Serialization error: \(e)")
                                errorToReturn = ErrorsNetworkAPIManager.jsonSerializationFailed
                            }
                        }else{
                            print("NetworkAPIManager:getData: unableToReadContentsOfURL")
                            errorToReturn = ErrorsNetworkAPIManager.unableToReadContentsOfURL
                        }
                        
                    }
                    
                    /**********
                     Note this pattern: sometimes due to many conditional checks we may miss to call completion which may lead to someone waiting infitintly, but by using Defer, we ensure that no matter what the completion is called at a relatively smaller cost.
                     **********/
                    defer{
                        completion(errorToReturn,dataObject)
                    }
                }
                downloadTask.resume()
            }
        }
    }
}
