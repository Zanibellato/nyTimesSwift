//
//  NewswireTableViewCell.swift
//  nytimes
//
//  Created by Valerio on 05/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class NewswireTableViewCell: UITableViewCell {
    
    //MARK: Properties

    @IBOutlet weak var NewswireTitleLabel: UILabel!
    
    @IBOutlet weak var NewswireThumbImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
