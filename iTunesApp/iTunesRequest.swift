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
    public var tunesArray : [iTune] = []
    var data : NSData?
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
        static let ArtistName = "artistName"
        static let ArtworkURL = "artworkUrl100"
        static let CollectionPrice = "collectionPrice"
        static let TrackPrice = "trackPrice"
        static let TrackId = "trackId"
        static let Currency = "currency"
    }

    func performRequest(handler: ([iTune]) -> Void) {
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
                    print(data!)
                    self.fetchTunes(data!, handler: handler)
                }
            }

        })
        dataTask?.resume()
    }
    
    func fetchTunes(data : NSData, handler: ([iTune]) -> Void) {
        do {
            let tuneDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! NSDictionary
            if let results : Array<NSDictionary> = tuneDictionary["results"] as? Array<NSDictionary> {
                for result in results {
                    let tune : iTune = iTune()
                    tune.artistName = result[iTunesKey.ArtistName] as? String
                    if let artworkURL = result[iTunesKey.ArtworkURL] as? String {
                        tune.artworkUrl = NSURL(string: artworkURL)
                    }
                    tune.country = result[iTunesKey.Country] as? String
                    if let collectionPrice = result[iTunesKey.CollectionPrice] as? Double {
                    tune.collectionPrice = collectionPrice
                    }
                    if let trackPrice = result[iTunesKey.TrackPrice] as? Double {
                        tune.trackPrice = trackPrice
                    }
                    
                    if let currency = result[iTunesKey.Currency] as? String {
                        tune.currency = currency
                    }
                    
                    tunesArray.append(tune)
                }
            }
           handler(tunesArray)
        } catch {
            print(error)
        }
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
