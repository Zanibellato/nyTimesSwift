//
//  TopStoriesTableViewCell.swift
//  nytimes
//
//  Created by Valerio on 06/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class TopStoriesTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var TopStoriesTitleText: UILabel!
    @IBOutlet weak var TopStoriesThumbImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
