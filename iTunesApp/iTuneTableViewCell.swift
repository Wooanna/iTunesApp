//
//  iTuneTableViewCell.swift
//  iTunesApp
//
//  Created by Yoanna Mareva on 6/28/16.
//  Copyright © 2016 Yoanna Mareva. All rights reserved.
//

import UIKit

class iTuneTableViewCell: UITableViewCell {
    
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trackPrice: UILabel!
    @IBOutlet weak var albumPrice: UILabel!
    
    var tune : iTune? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI () {
        self.titleLabel.textColor = UIColor.grayColor()
        self.backgroundColor = UIColor.clearColor()
        preview?.image = nil
        titleLabel?.text = nil
        
        if let tune = self.tune {
            
            self.titleLabel.text = tune.artistName
            self.trackPrice.text = String(tune.trackPrice)
            self.albumPrice.text = String(tune.collectionPrice)
            if let artworkURL = self.tune?.artworkUrl {
                
                //mainThread
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                    if let imageData = NSData(contentsOfURL: artworkURL) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.preview?.image = UIImage(data: imageData)
                        })
                    }
                })
            }

        }
    }
}
