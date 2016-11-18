//
//  FavoritesTableViewCell.swift
//  thomaskamps-pset3
//
//  Created by Thomas Kamps on 18-11-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var posterOutlet: UIImageView!
    @IBOutlet weak var subtitleOutlet: UILabel!
    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
