//
//  JSONData.swift
//  iOSMatchCentre
//
//  Created by George Davies on 14/08/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import Foundation

// Notification center unique key
let matchDataNCKey = "com.georgeddavies.matchdata"
let commentaryDataNCKey = "com.georgeddavies.commentarydata"

class MatchJSONData: NSObject {
    
    static let sharedInstance = MatchJSONData()
    var matchStatsJSON: NSDictionary?
    
    // Retreive all match stats data from JSON feed
    func getMatchStatsData() {
        let url = URL(string: "https://feeds.tribehive.co.uk/DigitalStadiumServer/opta?pageType=match&value=803294&v=5")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data {
                    // If successful pass data object to json variable as dictionary
                    do {
                        MatchJSONData.sharedInstance.matchStatsJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? NSDictionary
                        print("Got match data")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: matchDataNCKey), object: self)
                    } catch {
                        // Error popup
                        print("Error fetching data")
                    }
                } else {
                    // Error popup
                    print("Unable to retrieve data")
                }
            })
        })
        task.resume()
    }
}

class CommentaryJSONData: NSObject {
    
    static let sharedInstance = CommentaryJSONData()
    var commentaryJSON: NSArray?
    
    func getData() {
        let url = URL(string: "https://feeds.tribehive.co.uk/DigitalStadiumServer/opta?pageType=matchCommentary&value=803294&v=2")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data {
                    do {
                        // Retrieve array of dictionaries
                        CommentaryJSONData.sharedInstance.commentaryJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? NSArray
                        print("Got commentary data")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: commentaryDataNCKey), object: self)
                    } catch {
                        // Error popup
                        print("Error fetching data")
                    }
                } else {
                    // Error popup
                    print("Unable to retrieve data")
                }
            })
        })
        task.resume()
    }
}
