//
//  Article.swift
//  nytimes
//
//  Created by Valerio on 10/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class Article {
    
    //MARK: Properties
    
    var snippet: String
    var thumb: UIImage?
    var image: UIImage?
    var leadParagraph: String
    var url: NSURL
    
    //MARK: Initialization
    
    init(snippet: String, thumb: UIImage?, image: UIImage?, leadParagraph: String, url: NSURL){
        
        self.snippet = snippet
        self.thumb = thumb
        self.image = image
        self.leadParagraph = leadParagraph
        self.url = url
        
    
    }
    
    


}
