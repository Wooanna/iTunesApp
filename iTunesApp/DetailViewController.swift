//
//  TuneDetailViewController.swift
//  iTunesApp
//
//  Created by Yoanna Mareva on 6/30/16.
//  Copyright © 2016 Yoanna Mareva. All rights reserved.
//

import UIKit

public class DetailViewController: UIViewController {

    public var artworkPreviewURL : NSURL! {
        didSet {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                if let imageData = NSData(contentsOfURL: self.artworkPreviewURL) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.artworkPreview.image = UIImage(data: imageData)
                    })
                }
            })
        }
    }
    
    @IBOutlet weak var artworkPreview: UIImageView!
    
    @IBOutlet weak var trackPrice: UILabel! {
        didSet {
        trackPrice.text = "track price"
        }
    }
    @IBOutlet weak var collectionPrice: UILabel! {
        didSet {
        collectionPrice.text = "collection price"
        }
    }
    @IBOutlet weak var artistName: UILabel! {
        didSet {
        artistName.text = "artist name"
        }
    }
    @IBOutlet weak var collectionName: UILabel! {
        didSet {
        collectionName.text = "collection name"
        }
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    }

