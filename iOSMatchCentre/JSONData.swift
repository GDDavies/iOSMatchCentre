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
    var homeTeamStatsDict = [String : Any]()
    
    var competition: String?
    var venue: String?
    var attendance: String?
    var referee: String?
    var homeTeamName: String?
    var awayTeamName: String?
    var homeTeamScore: String?
    var awayTeamScore: String?
    
    // Retreive all match stats data from JSON feed
    func getMatchStatsData() {
        let url = URL(string: "https://feeds.tribehive.co.uk/DigitalStadiumServer/opta?pageType=match&value=803294&v=5")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data {
                    // If successful pass data object to json variable as dictionary
                    do {
                        MatchJSONData.sharedInstance.matchStatsJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? NSDictionary
                        self.populateMatchStatsData()
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
    
    func populateMatchStatsData() {
        if let competitionName = MatchJSONData.sharedInstance.matchStatsJSON?["competition"] {
            competition = String(describing: competitionName)
        }
        if let venueName = MatchJSONData.sharedInstance.matchStatsJSON?["venue"] {
            venue = String(describing: venueName)
        }
        if let attendanceSize = MatchJSONData.sharedInstance.matchStatsJSON?["attendance"] {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            let formattedAttendance = numberFormatter.string(from: NSNumber(value:attendanceSize as! Int))
            attendance = "Attendance: \(formattedAttendance!)"
        }
        if let refereeName = MatchJSONData.sharedInstance.matchStatsJSON?["referee"] {
            referee = "Ref: " + String(describing: refereeName)
        }
        if let homeTeam = MatchJSONData.sharedInstance.matchStatsJSON?["home"] as? NSDictionary {
            if let homeTeamNameText = homeTeam["name"] {
                homeTeamName = String(describing: homeTeamNameText)
            }
        }
        if let awayTeam = MatchJSONData.sharedInstance.matchStatsJSON?["away"] as? NSDictionary {
            if let awayTeamNameText = awayTeam["name"] {
                awayTeamName = String(describing: awayTeamNameText)
            }
        }
        if let homeTeamStats = MatchJSONData.sharedInstance.matchStatsJSON?["homeStats"] as? NSDictionary {
            homeTeamStatsDict = homeTeamStats as! [String : Any]
            if let homeTeamScoreText = homeTeamStats["score"] {
                homeTeamScore = String(describing: homeTeamScoreText)
            }
        }
        if let awayTeamStats = MatchJSONData.sharedInstance.matchStatsJSON?["awayStats"] as? NSDictionary {
            if let awayTeamScoreText = awayTeamStats["score"] {
                awayTeamScore = String(describing: awayTeamScoreText)
            }
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: matchDataNCKey), object: self)
    }
}

class CommentaryJSONData: NSObject {
    
    static let sharedInstance = CommentaryJSONData()
    var commentaryJSON: NSArray?
    
    func getMatchCommentaryData() {
        let url = URL(string: "https://feeds.tribehive.co.uk/DigitalStadiumServer/opta?pageType=matchCommentary&value=803294&v=2")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data {
                    do {
                        // Retrieve array of dictionaries
                        CommentaryJSONData.sharedInstance.commentaryJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? NSArray
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
