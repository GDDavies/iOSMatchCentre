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
        let color = awayStatsView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if(selected) {
            awayStatsView.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = awayStatsView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted) {
            awayStatsView.backgroundColor = color
        }
    }
}
