//
//  TopStory.swift
//  nytimes
//
//  Created by Valerio on 06/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class TopStory: NSObject, NSCoding {
    
    //MARK: Propeties
    var section: String
    var title: String
    var thumb: UIImage?
    var abstract: String
    var image: UIImage?
    
    struct PropertyKey {
    
        static let sectionKey = "section"
        static let titleKey = "title"
        static let thumbKey = "thumb"
        static let abstractKey = "abstract"
        static let imageKey = "image"
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("topStories")
    
    
    //MARK: Initialization
    
    init?(section: String, title: String, thumb: UIImage, abstract: String, image: UIImage){
        
        self.section = section
        self.title = title
        self.thumb = thumb
        self.abstract = abstract
        self.image = image
        
        super.init()
        
        if title.isEmpty || abstract.isEmpty || section.isEmpty{
            return nil
        }
        
        
    }
    
    //Mark: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(section, forKey: PropertyKey.sectionKey)
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(thumb, forKey: PropertyKey.thumbKey)
        aCoder.encodeObject(abstract, forKey: PropertyKey.abstractKey)
        aCoder.encodeObject(image, forKey: PropertyKey.imageKey)
    }
    
    required convenience init?(coder aCoder: NSCoder) {
        let section = aCoder.decodeObjectForKey(PropertyKey.sectionKey) as! String
        let title = aCoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        let thumb = aCoder.decodeObjectForKey(PropertyKey.thumbKey) as? UIImage
        let abstract = aCoder.decodeObjectForKey(PropertyKey.abstractKey) as! String
        let image = aCoder.decodeObjectForKey(PropertyKey.imageKey) as? UIImage
        
        self.init(section: section, title: title, thumb: thumb!, abstract: abstract, image: image!)
        
    }
    
}
