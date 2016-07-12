//
//  Newswire.swift
//  nytimes
//
//  Created by Valerio on 05/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class Newswire {

    //MARK: Propeties
    var section: String
    var title: String
    var thumb: UIImage?
    var abstract: String
    var image: UIImage?
    
    //MARK: Initialization
    
    //Constructor
    init?(section: String, title: String, thumb: UIImage, abstract: String, image: UIImage){
        
        self.section = section
        self.title = title
        self.thumb = thumb
        self.abstract = abstract
        self.image = image
        
        //If some of the parameters are nil return nil
        if title.isEmpty || abstract.isEmpty || section.isEmpty{
            return nil
        }
    }
    
    
}
