//
//  EventTableViewCell.swift
//  iOSMatchCentre
//
//  Created by George Davies on 19/08/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var homeEventDescription: UILabel!
    @IBOutlet weak var homeEventTime: UILabel!
    
    @IBOutlet weak var awayEventDescription: UILabel!
    @IBOutlet weak var awayEventTime: UILabel!
    
    @IBOutlet weak var dividerView: UIView!
    
    @IBOutlet weak var dividerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerViewBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
