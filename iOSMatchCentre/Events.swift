//
//  MatchEvent.swift
//  iOSMatchCentre
//
//  Created by George Davies on 17/08/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import Foundation
//import UIKit

class CommentaryEvent: NSObject {
    
    var eventType: String?
    var eventTime: String?
    var eventHeading: String?
    var eventDescription: String?
}

class MatchEvent: NSObject {
    var type: String?
    var when: Int?
    var whom: String?
    var isHome: Bool?
    var subOn: String?
    var subOff: String?
}
