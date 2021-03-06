//
//  TuneDetailViewController.swift
//  iTunesApp
//
//  Created by Yoanna Mareva on 6/30/16.
//  Copyright © 2016 Yoanna Mareva. All rights reserved.
//

import UIKit
import CoreData

public class DetailViewController: UIViewController, UIGestureRecognizerDelegate {

    let like = UIImage(named: "like")
    let likeFilled = UIImage(named: "likeFilled")
    let mask = CAGradientLayer()
    var bgImage = UIImageView()
    
    var tune : iTune? {
        didSet {
            if let artworkURL = tune?.artworkUrl?.absoluteString {
                if(exists(artworkURL).exists == false) {
                    favIcon.image = like
                } else {
                    favIcon.image = likeFilled
                }
            }
        }
    }
    
    func handleFav(sender: UITapGestureRecognizer) {
        if(favIcon.image == likeFilled) {
            favIcon.image = like
            if let artworkURL = tune?.artworkUrl?.absoluteString {
                if(exists(artworkURL).exists == true) {
                     removeFromFavorites(exists(artworkURL).tune!)
                }
            }
        } else {
            favIcon.image = likeFilled
            
            if let artworkURL = tune?.artworkUrl?.absoluteString {
                if(exists(artworkURL).exists == false) {
                    seedFavoritesWithID(artworkURL)
                }
            }
        }
    }
    
    @IBOutlet weak var kind: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var country: UILabel!
    
    public var artworkPreviewURL : NSURL! {
        didSet {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                if let imageData = NSData(contentsOfURL: self.artworkPreviewURL) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.artworkPreview.image = UIImage(data: imageData)
                        self.bgImage.image = UIImage(data: imageData)
                    })
                }
            })
        }
    }
    
    @IBOutlet weak var favIcon: UIImageView! {
        didSet {
            favIcon.image = like
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.handleFav(_:)))
            favIcon.userInteractionEnabled = true
            favIcon.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var artworkPreview: UIImageView! {
        didSet {
            let colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
            mask.colors = colors
            mask.startPoint = CGPoint(x: 0.0, y: 1)
            mask.endPoint = CGPoint(x: 0.0, y: 0.7)
            artworkPreview.layer.mask = mask
        }
    }
    
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
    
    // MARK: App lifecycle
    
    public override func viewDidLoad() {
        bgImage = UIImageView(frame: self.view.frame)
        bgImage.image = UIImage(named: "mesh2")
        bgImage.contentMode = .ScaleAspectFill
        self.view.insertSubview(bgImage, atIndex: 0)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        view.insertSubview(blurEffectView, atIndex: 1)
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mask.frame = artworkPreview.bounds
  
    }
    //MARK: Data base manage
    
    private struct DBMConstants {
        static let FavoriteTune = "FavoriteTune"
        static let FetchFail = "failier to fetch itemID"
        static let SaveFail = "failed to save itemID"
        static let DeleteFail = "failed to delete itemID"
    }
    
    let moc = DBManager().managedObjectContext
    
    func exists(itemID: String) -> (exists: Bool, tune: FavoriteTune?){
        let favoriteFetch = NSFetchRequest(entityName: DBMConstants.FavoriteTune)
        do {
            let fetchedFavorite = try moc.executeFetchRequest(favoriteFetch) as! [FavoriteTune]
            if let found = fetchedFavorite.indexOf({$0.itemid! == itemID})  {
                return (true, fetchedFavorite[found])
            } else {
                return (false, nil)
            }
        } catch {
            fatalError(DBMConstants.FetchFail)
        }
    }
    
    func seedFavoritesWithID(itemID: String) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName(DBMConstants.FavoriteTune, inManagedObjectContext: moc) as! FavoriteTune
        entity.setValue(itemID, forKey: "itemid")
        do {
            try moc.save()
        } catch {
            fatalError(DBMConstants.SaveFail)
        }
    }
    
    func removeFromFavorites(tune: FavoriteTune) {
        moc.deleteObject(tune)
        do {
        try moc.save()
        } catch {
            fatalError(DBMConstants.DeleteFail)
        }
    }
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest(entityName: DBMConstants.FavoriteTune)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try moc.executeRequest(deleteRequest)
        } catch  {
            fatalError(DBMConstants.DeleteFail)
        }
    }
}

