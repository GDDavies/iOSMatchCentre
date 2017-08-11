//
//  MatchStatsViewController.swift
//  iOSMatchCentre
//
//  Created by George Davies on 11/08/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

class MatchStatsViewController: UIViewController {

    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var homeTeamScore: UILabel!
    
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var awayTeamScore: UILabel!
    
    @IBOutlet weak var competitionNameLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var refereeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMatchStatsData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup Match Stats Data
    
    func getMatchStatsData() {
        let url = URL(string: "https://feeds.tribehive.co.uk/DigitalStadiumServer/opta?pageType=match&value=803294&v=5")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data {
                    self.populateMatchStatsData(unwrappedData)
                } else {
                    // Error popup
                    print("Unable to retrieve data")
                }
            })
        })
        task.resume()
    }
    
    func populateMatchStatsData(_ matchStatsData: Data) {
        do {
            // Retrieve dictionary
            let json = try JSONSerialization.jsonObject(with: matchStatsData, options: []) as! NSDictionary
            
            if let competitionName = json["competition"] {
                competitionNameLabel.text = String(describing: competitionName)
            }
            if let venueName = json["venue"] {
                venueLabel.text = String(describing: venueName)
            }
            if let attendanceSize = json["attendance"] {
                attendanceLabel.text = "Attendance: " + String(describing: attendanceSize)
            }
            if let refereeName = json["referee"] {
                refereeLabel.text = "Ref: " + String(describing: refereeName)
            }
            
            if let homeTeam = json["home"] as? NSDictionary {
                
                if let homeTeamNameText = homeTeam["name"] {
                    homeTeamName.text = String(describing: homeTeamNameText)
                }
            }
            
            if let awayTeam = json["away"] as? NSDictionary {
                
                if let awayTeamNameText = awayTeam["name"] {
                    awayTeamName.text = String(describing: awayTeamNameText)
                }
            }
            
            if let homeTeamStats = json["homeStats"] as? NSDictionary {
                
                if let homeTeamScoreText = homeTeamStats["score"] {
                    homeTeamScore.text = String(describing: homeTeamScoreText)
                }
            }
            
            if let awayTeamStats = json["awayStats"] as? NSDictionary {
                
                if let awayTeamScoreText = awayTeamStats["score"] {
                    awayTeamScore.text = String(describing: awayTeamScoreText)
                }
            }
            
            
//            if let standings = json["standings"] as? NSDictionary {
//                if let resultsArray = standings["results"] as? NSArray {
//                    for i in 0..<resultsArray.count {
//                        if let teamData = resultsArray[i] as? NSDictionary {
//                            let teamName = teamData["entry_name"]
//                            let rank = teamData["rank"]
//                            let teamPoints = teamData["total"]
//                            
//                            names.add(teamName!)
//                            ranks.add(rank!)
//                            points.add(teamPoints!)
//                        }
//                    }
//                }
//            }
//            
//            // Loop through array and assign each value to array
//            for i in 0..<json.count {
//                if let matchEvent = json[i] as? NSDictionary {
//
//                }
//            }
            // Reload view once all JSON data is loaded
            //tableView.reloadData()
        } catch {
            // Error popup
            print("Error fetching data")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
