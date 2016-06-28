//
//  SearchViewController.swift
//  iTunesApp
//
//  Created by Yoanna Mareva on 6/27/16.
//  Copyright © 2016 Yoanna Mareva. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var bgImageView: UIImageView!    
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bgImageView.image = UIImage(named: "mesh1")
        resultsTableView.backgroundColor = UIColor.clearColor()
        let parameters = ["term": "johnson"]
        let request = iTunesRequest("", parameters)
        request.performRequest()
    }
}
