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
    
    var tune : iTune? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI () {
        preview?.image = nil
        titleLabel?.text = nil
        
        if let tune = self.tune {
            self.titleLabel.text = tune.trackName
            
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
