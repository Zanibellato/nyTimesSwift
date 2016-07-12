//
//  ArticlesViewController.swift
//  nytimes
//
//  Created by Valerio on 04/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit



class ArticleViewController: UIViewController {
    
    //MARK: Properties
    
    var article : Article!
    
    @IBOutlet weak var ArticleImage: UIImageView!
    @IBOutlet weak var ArticleSnippet: UILabel!
    @IBOutlet weak var ArticleLeadParagraph: UITextView!
    @IBOutlet weak var ArticleUrlButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let article = article {
            
            //Set up the View parameters
            
            ArticleImage.image = article.image
            ArticleSnippet.text = article.snippet
            ArticleLeadParagraph.text = article.leadParagraph
            
            //If the article has valid url enable the "read more" button
            if article.url.absoluteString != "" {
             ArticleUrlButton.enabled = true
            }
            
        
        }
    }
    
    //From the Detail View to the web View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if ArticleUrlButton === sender{
            
            //Add the Article object to the destinationViewController
            let articleUrlViewController = segue.destinationViewController as! ArticleWebViewController
            articleUrlViewController.article = article
            
        }
    }
    
    
    
    
}
