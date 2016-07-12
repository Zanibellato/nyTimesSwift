//
//  StoredNewsTableViewCell.swift
//  nytimes
//
//  Created by Valerio on 08/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class StoredNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var StoredNewsThumbImage: UIImageView!
    @IBOutlet weak var StoredNewsTitleText: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
