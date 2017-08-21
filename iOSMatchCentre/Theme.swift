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
    
    // Main team colours
    static var primaryTeamColour = UIColor(red: 39/255, green: 68/255, blue: 135/255, alpha: 1.0)
    static var secondaryTeamColour = UIColor.white
    
    // Table Section Headers
    static var sectionHeaderTitleFont = UIFont(name: "Helvetica-Bold", size: 20)
    static var sectionHeaderTitleColor = UIColor.white
    static var sectionHeaderBackgroundColor = UIColor.black
    static var sectionHeaderBackgroundColorHighlighted = UIColor.gray
    static var sectionHeaderAlpha: CGFloat = 1.0
}

struct TeamColours {
    static let primaryColour = [
        "Everton": UIColor(red: 39/255, green: 68/255, blue: 135/255, alpha: 1.0),
        "Bournemouth": UIColor(red: 230/255, green: 35/255, blue: 51/255, alpha: 1.0)
    ]
    
    static let secondaryColour = [
        "Everton": UIColor.white,
        "Bournemouth": UIColor.black
    ]
}
