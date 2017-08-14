//
//  Theme.swift
//  iOSMatchCentre
//
//  Created by George Davies on 12/08/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

//import Foundation
import UIKit

struct Theme{
    
    // MARK: - Team colours
    static var primaryTeamColour = UIColor(red: 39/255, green: 68/255, blue: 135/255, alpha: 1.0)
    static var secondaryTeamColour = UIColor.white
    
    // MARK: - ToDo Table Section Headers
    static var sectionHeaderTitleFont = UIFont(name: "Helvetica-Bold", size: 20)
    static var sectionHeaderTitleColor = UIColor.white
    static var sectionHeaderBackgroundColor = UIColor.black
    static var sectionHeaderBackgroundColorHighlighted = UIColor.gray
    static var sectionHeaderAlpha: CGFloat = 1.0
}

class TeamInformation {
    let logoList = [
        "t11": "Everton",
        "t91": "Bournemouth"
    ]
}

struct TeamColours {
    static let primaryColour = [
        "t11": UIColor(red: 39/255, green: 68/255, blue: 135/255, alpha: 1.0),
        "t91": UIColor(red: 230/255, green: 35/255, blue: 51/255, alpha: 1.0)
    ]
}
