//
//  SearchViewController.swift
//  iTunesApp
//
//  Created by Yoanna Mareva on 6/27/16.
//  Copyright © 2016 Yoanna Mareva. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    var iTunes = [iTune]()
    var searchText : String? = "Search text" {
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
    @IBOutlet weak var resultsTableView: UITableView! {
        didSet {
            resultsTableView.delegate = self
            resultsTableView.dataSource = self
        }
    }
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var searchBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bgImageView.image = UIImage(named: "mesh1")
        resultsTableView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
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
                        self.resultsTableView.reloadData()
                    }
                    
                })
            }

        }
    }

    func blurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = resultsTableView.frame
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
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iTunes.count
    }
    
    private struct Storyboard {
        static let CellReuseIdentifier = "iTuneCell"
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! iTuneTableViewCell
        
        //cell configuration
        cell.tune = iTunes[indexPath.row]
        return cell
    }

}
