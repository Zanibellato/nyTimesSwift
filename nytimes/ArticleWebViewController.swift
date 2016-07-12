//
//  ArticleWebViewController.swift
//  nytimes
//
//  Created by Valerio on 10/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class ArticleWebViewController: UIViewController {

    //MARK: Properties
    
    var article: Article!
    
    //The browser
    @IBOutlet weak var browser: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load the article's url
        let myURLRequest = NSURLRequest(URL: article.url)
        browser.loadRequest(myURLRequest)
    }

    
}
