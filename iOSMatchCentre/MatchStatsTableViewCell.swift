//
//  MatchStatsTableViewCell.swift
//  iOSMatchCentre
//
//  Created by George Davies on 11/08/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

class MatchStatsTableViewCell: UITableViewCell {

    @IBOutlet weak var awayStatsView: UIView!
    @IBOutlet weak var homeStatLabel: UILabel!
    @IBOutlet weak var awayStatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
