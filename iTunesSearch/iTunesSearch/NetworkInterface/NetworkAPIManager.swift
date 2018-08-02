//
//  NetworkAPIManager.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation


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


/**********
 All network calls routed through this guy.
 **********/
class NetworkAPIManager {
    
    let defaultSession = URLSession(configuration: .default)
    
    
    
    //MARK:- Errors
    enum ErrorsNetworkAPIManager: Error{
        case jsonSerializationFailed, unableToReadContentsOfURL
    }
    
    //MARK:- system cache configuration.
    class func configureCache(){
        /*
         Configuring a cache of 500MB.
         */
        let cacheSizeMemory = 500*1024*1024
        let cacheSizeDisk = 500*1024*1024
        let sharedCache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: "nsurlcache")
        URLCache.shared = sharedCache
    }
    
    
    
}

extension NetworkAPIManager: APIManagerInterface{
    //**********************
    //MARK:- GetImage
    //**********************
    
    func dataFrom(endPoint:Endpoint, completion:@escaping APIManagerInterface.DataFromCompletionHandler){
        DispatchQueue.global().async {
            
            
            if let url = endPoint.url{
                print("url:\(url)")
                let dataTask = self.defaultSession.dataTask(with: url) { (data, urlresponse, error) in
                    
                    /**********
                     Note: sometimes due to many conditional checks we may miss to call completion which may lead to someone waiting infitintly, but by using Defer, we ensure that no matter what the completion is called at a relatively smaller cost.
                     **********/
                    var errorToReturn:Error? = nil
                    var dataObject:Data? = nil
                    
                    defer{
                        completion(errorToReturn,dataObject)
                    }
                    

                    
                    // First establish the return value
                    errorToReturn = error
                    dataObject = data

                    guard errorToReturn == nil else{
                        print("NetworkAPIManager:dataFrom: Error: \(String(describing: error))")
                        return
                    }
                    
                }
                dataTask.resume()
            }
        }
    }
    
    
    /**********
     GetData: used to establish a download task for a particular endpoint.
     **********/
    
    func downloadJsonFrom(endPoint:Endpoint, completion:@escaping APIManagerInterface.DownloadJsonCompletionHandler) {
        DispatchQueue.global().async {
            

            
            if let url = endPoint.url{
                let downloadTask = self.defaultSession.downloadTask(with: url) { (url, urlResponse, error) in
                    
                    /**********
                     Note this pattern: sometimes due to many conditional checks we may miss to call completion which may lead to someone waiting infitintly, but by using Defer, we ensure that no matter what the completion is called at a relatively smaller cost.
                     **********/
                    // First establish the return value
                    var errorToReturn:Error? = nil
                    var dataObject:[String:Any]? = nil
                    
                    defer{
                        completion(errorToReturn,dataObject)
                    }
                    
                    guard error == nil else{
                        print("NetworkAPIManager:getData: Error: \(String(describing: error))")
                        errorToReturn = error
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
                    
                }
                downloadTask.resume()
            }
        }
    }
}
