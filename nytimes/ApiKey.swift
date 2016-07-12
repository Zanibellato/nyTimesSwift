//
//  ApiKey.swift
//  nytimes
//
//  Created by Valerio on 11/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class ApiKey: NSObject {
    
    let keys: NSUserDefaults
    
    override init() {
        keys = NSUserDefaults.standardUserDefaults()
    }
    
    func loadAPIKeys(){
        
        //Set the default values for the API keys referenced by the API name
        self.keys.setValue("442b8bb5195cb444710b2a62e8a175a9:14:73649889", forKey: "articles")
        self.keys.setValue("b297dded819a99252edd8bd2579dabc7:1:73649889", forKey: "newswire")
        self.keys.setValue("fa0897bb2f5af594046083907d02b1d8:19:73649889", forKey: "topstories")
    
    }
    

}
