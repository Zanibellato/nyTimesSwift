//
//  ArticleTableViewCell.swift
//  nytimes
//
//  Created by Valerio on 10/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var ArticleThumbImage: UIImageView!
    @IBOutlet weak var ArticleSnippetText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
