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
    var searchText : String? = "Search text" {
        didSet {
            searchInput?.text = searchText
            iTunes.removeAll()
            resultsCollection.reloadData()
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
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var searchBtn: UIButton!
    
    var layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        bgImageView.image = UIImage(named: "mesh1")
        resultsCollection.backgroundColor = UIColor.clearColor()
        blurEffect()
    }
    
    @IBAction func search(sender: AnyObject) {
                if let input = searchInput.text {
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

    func blurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let frame = CGRect(x: resultsCollection.frame.minX, y: resultsCollection.frame.minY-75, width: resultsCollection.frame.width, height: resultsCollection.frame.width)
        let blurEffectView = BlurView(effect: blurEffect, frame: frame)
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
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
        //cell configuration
        cell.tune = iTunes[indexPath.row]
        return cell

    }
    
    // MARK: UICollectionViewFlowLayoutDelegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 130, height: 130)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }

}
