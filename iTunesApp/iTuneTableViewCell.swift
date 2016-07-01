//
//  iTuneTableViewCell.swift
//  iTunesApp
//
//  Created by Yoanna Mareva on 6/28/16.
//  Copyright © 2016 Yoanna Mareva. All rights reserved.
//

import UIKit

class iTuneTableViewCell: UICollectionViewCell {

    @IBOutlet weak var trackPrice: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumPrice: UILabel!
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var favIcon: UIImageView!
    
    var tune : iTune? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI () {
        self.titleLabel.textColor = UIColor.grayColor()
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        self.trackPrice.textColor = UIColor.grayColor()
        self.trackPrice.font = UIFont(name: "AvenirNext-UltraLightItalic", size: 11)
        self.albumPrice.textColor = UIColor.grayColor()
        self.albumPrice.font = UIFont(name: "AvenirNext-UltraLightItalic", size: 11)
        
        preview?.image = nil
        titleLabel?.text = nil
        trackPrice.text = "N/A"
        albumPrice.text = "N/A"
        
        if let tune = self.tune {
            
            self.titleLabel.text = tune.artistName
            if let trackPrice = tune.trackPrice {
                self.trackPrice.text = "\(trackPrice)"
            }
            
            if let albumPrice = tune.collectionPrice {
                self.albumPrice.text = "\(albumPrice)"
            }
            
            if(tune.isFav) {
                favIcon.image = UIImage(named: "likeFilled")
            } else {
                favIcon.image = UIImage(named: "like")
            }
            
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
