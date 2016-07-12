//
//  FirstViewController.swift
//  nytimes
//
//  Created by Valerio on 04/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class NewswireViewController: UIViewController{
    //MARK: Properties
    
    
    @IBOutlet weak var NewswireImage: UIImageView!
    @IBOutlet weak var NewswireTitle: UILabel!
    @IBOutlet weak var NewswireAbstract: UITextView!


    
    var newswire: Newswire!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the View parameters
        
        if let newswire = newswire {
            
            navigationItem.title = newswire.section
            NewswireTitle.text = newswire.title
            NewswireImage.image = newswire.image
            NewswireAbstract.text = newswire.abstract
            
        }
        
        
                
    }
    


}

