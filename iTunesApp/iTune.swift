//
//  iTune.swift
//  iTunesApp
//
//  Created by Yoanna Mareva on 6/28/16.
//  Copyright © 2016 Yoanna Mareva. All rights reserved.
//

import UIKit

public class iTune: NSObject {
    
    public var kind : String?
    public var artistName : String?
    public var collectionName : String?
    public var trackName : String?
    public var artworkUrl : NSURL? {
        didSet {
            artworkUrl600 = NSURL(string: (artworkUrl?.absoluteString.stringByReplacingOccurrencesOfString("100x100", withString: "600x600"))!)
        }
    }
    public var artworkUrl600 : NSURL?
    public var collectionPrice : Double?
    public var trackPrice : Double?
    public var country : String?
    public var genre: String?

}
