//
//  iTunesRequest.swift
//  iTunesApp
//
//  Created by Yoanna Mareva on 6/27/16.
//  Copyright © 2016 Yoanna Mareva. All rights reserved.
//

import UIKit

public class iTunesRequest: NSObject, NSURLSessionDelegate {
    
    public var requestType: String
    public var parameters = Dictionary<String, String>()
    public var responseData : NSMutableData = NSMutableData()
    // designated initializer
    public init(_ requestType: String, _ parameters: Dictionary<String, String> = [:]) {
        self.requestType = requestType
        self.parameters = parameters
    }

    let JSONExtension = ".json"
    let iTunesURLPrefix = "https://itunes.apple.com/search?"
    
    struct iTunesKey {
        static let Term = "term"
        static let Country = "country"
        static let Media = "media"
        static let Entity = "entity"
        static let Attribute = "attribute"
        static let Callback = "callback"
        static let Limit = "limit"
        static let Language = "lang"
        static let Explicit = "explicit"
        static let Version = "version"
    }

    func performRequest() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
        var dataTask: NSURLSessionDataTask?
        dataTask = session.dataTaskWithURL(requestURL(), completionHandler: { (data, response, error) in
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print(response?.description)
                }
            }
        })
        dataTask?.resume()
       
    }
    
    func requestURL() -> NSURL {
         var key = ""
         var value = ""
        for (k, v) in parameters{
            key = k
            value = v
        }
      
        let reqURL = NSURL(string: "\(iTunesURLPrefix)\(key)=\(value)")
         print(reqURL)
        return reqURL!
        
    }
    
    
}
