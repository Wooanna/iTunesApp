//
//  SearchViewController.swift
//  iTunesApp
//
//  Created by Yoanna Mareva on 6/27/16.
//  Copyright © 2016 Yoanna Mareva. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var iTunes = [iTune]()
    var searchText :String? = "Search text" {
        didSet {
            searchInput?.text = searchText
        }
    }

    @IBOutlet weak var searchInput: UITextField! {
        didSet {
            searchInput.delegate = self
            searchInput.text = self.searchText
        }
    }
    
    @IBOutlet weak var resultsCollection: UICollectionView! {
        didSet {
            resultsCollection.delegate = self
            resultsCollection.dataSource = self
        }
    }
    
    @IBOutlet weak var searchBtn: UIButton! {
        didSet {
            searchBtn.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
            searchBtn.layer.cornerRadius = searchBtn.frame.width/2
        }
    }
    
    var blurEffectView : BlurView! = nil
    
    //MARK: App lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImageView = UIImageView(frame: self.view.frame)
        bgImageView.image = UIImage(named: "mesh1")
        self.view.insertSubview(bgImageView, atIndex: 0)
        bgImageView.contentMode = UIViewContentMode.ScaleAspectFill
       
        resultsCollection.backgroundColor = UIColor.clearColor()
        blurEffect()
    }
    
     override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @IBAction func search(sender: AnyObject) {
                if let input = searchInput.text?.stringByReplacingOccurrencesOfString(" ", withString: "+") {
            let parameters = ["term": input]
            let request = iTunesRequest("", parameters)
            request.performRequest { (fetchedTunes) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if fetchedTunes.count > 0 {
                        self.iTunes = fetchedTunes
                        self.resultsCollection.reloadData()
                    }
                })
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "TuneDetails") {
            _ = segue.destinationViewController.contentViewController.view
            if let tune = (sender as! iTuneTableViewCell).tune {
                if let tuneDetailVC = segue.destinationViewController.contentViewController as? DetailViewController {
                    tuneDetailVC.tune = tune
                    if let artistName = tune.artistName {
                        tuneDetailVC.artistName.text = "By: \(artistName)"
                    } else {
                        tuneDetailVC.artistName.text = "By: unknown"
                    }
                    
                    if let collectionName = tune.collectionName {
                        tuneDetailVC.collectionName.text = "Album: \(collectionName)"
                    } else {
                        tuneDetailVC.collectionName.text = "Album: unknown"
                    }
                  
                    tuneDetailVC.collectionPrice.text = "Collection price: \(tune.collectionPrice!)\(tune.currency!)"
                    tuneDetailVC.trackPrice.text = "Track price: \(tune.trackPrice!)\(tune.currency!)"
                    tuneDetailVC.artworkPreviewURL = tune.artworkUrl600
                    tuneDetailVC.country.text = tune.country
                    tuneDetailVC.genre.text = tune.genre
                    tuneDetailVC.kind.text = tune.kind
                  
                }
            }
        }
    }

    func blurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 100)
        self.blurEffectView = BlurView(effect: blurEffect, frame: frame)
       
        view.insertSubview(blurEffectView, atIndex: 1)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchInput {
            textField.resignFirstResponder()
            searchText = textField.text!
        }
        return true
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iTunes.count
    }
    
    private struct Storyboard {
        static let CellReuseIdentifier = "iTuneCell"
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
               let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! iTuneTableViewCell
        cell.tune = iTunes[indexPath.row]
        return cell
    }
    
    // MARK: UICollectionViewFlowLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3.1, height: collectionView.frame.width / 3.1)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
}

extension UIViewController {
    var contentViewController : UIViewController {
        if let navCon = self as? UINavigationController {
            return navCon.visibleViewController!
        } else {
            return self
        }
    }
}
