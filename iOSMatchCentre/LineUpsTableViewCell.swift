//
//  LineUpsTableViewCell.swift
//  iOSMatchCentre
//
//  Created by George Davies on 12/08/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

class LineUpsTableViewCell: UITableViewCell {

    @IBOutlet weak var homePlayerNameLabel: UILabel!
    @IBOutlet weak var homePlayerNumberLabel: UILabel!
    
    @IBOutlet weak var awayPlayerNameLabel: UILabel!
    @IBOutlet weak var awayPlayerNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
