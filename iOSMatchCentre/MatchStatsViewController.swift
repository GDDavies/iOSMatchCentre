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
    
    @IBOutlet weak var containerViewA: UIView!
    @IBOutlet weak var containerViewB: UIView!
    @IBOutlet weak var containerViewC: UIView!
    
    var homeID: String?
    var awayID: String?
    
    var homeTeamStatsDict = [String : Any]()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func matchStatsSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.view.addSubview(containerViewA)
        } else if sender.selectedSegmentIndex == 1 {
            self.view.addSubview(containerViewC)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMatchStatsData()
        self.view.addSubview(containerViewA)
        MatchJSONData.sharedInstance.getMatchStatsData()
        NotificationCenter.default.addObserver(self, selector: #selector(MatchStatsViewController.test), name: NSNotification.Name(rawValue: matchDataNCKey), object: nil)
    }
    
    func test() {
        print(MatchJSONData.sharedInstance.matchStatsJSON?.count)
    }
    
    func otherTest() {
        //print(JSONMatchLineUpsData.lineUpsSharedInstance.lineUpJSON!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup Match Stats Data
    
    // Retreive all match stats data from JSON feed
    func getMatchStatsData() {
        let url = URL(string: "https://feeds.tribehive.co.uk/DigitalStadiumServer/opta?pageType=match&value=803294&v=5")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data {
                    // If successful pass data object to populate function
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
            // Create diciotnary from JSON data object
            let json = try JSONSerialization.jsonObject(with: matchStatsData, options: []) as! NSDictionary
            
            if let competitionName = json["competition"] {
                competitionNameLabel.text = String(describing: competitionName)
            }
            if let venueName = json["venue"] {
                venueLabel.text = String(describing: venueName)
            }
            if let attendanceSize = json["attendance"] {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                let formattedAttendance = numberFormatter.string(from: NSNumber(value:attendanceSize as! Int))
                attendanceLabel.text = "Attendance: \(formattedAttendance!)"
            }
            if let refereeName = json["referee"] {
                refereeLabel.text = "Ref: " + String(describing: refereeName)
            }
            
            if let homeTeam = json["home"] as? NSDictionary {
                
                if let homeTeamNameText = homeTeam["name"] {
                    homeTeamName.text = String(describing: homeTeamNameText)
                }
                
                if let homeTeamID = homeTeam["id"] {
                    homeID = String(describing: homeTeamID)
                }
            }
            
            if let awayTeam = json["away"] as? NSDictionary {
                
                if let awayTeamNameText = awayTeam["name"] {
                    awayTeamName.text = String(describing: awayTeamNameText)
                }
                
                if let awayTeamID = awayTeam["id"] {
                    awayID = String(describing: awayTeamID)
                }
            }
            
            if let homeTeamStats = json["homeStats"] as? NSDictionary {
                
                homeTeamStatsDict = homeTeamStats as! [String : Any]
                
                if let homeTeamScoreText = homeTeamStats["score"] {
                    homeTeamScore.text = String(describing: homeTeamScoreText)
                }
                
                //performSegue(withIdentifier: "ShowMatchStatsBars", sender: Any?.self)
            }
            
            if let awayTeamStats = json["awayStats"] as? NSDictionary {
                
                if let awayTeamScoreText = awayTeamStats["score"] {
                    awayTeamScore.text = String(describing: awayTeamScoreText)
                }
            }
            
            // Reload view once all JSON data is loaded
            //tableView.reloadData()
            loadLogos()
        } catch {
            // Error popup
            print("Error fetching data")
        }
    }
    
    func loadLogos() {
        let teamLogos = TeamInformation()

        let homeTeamLogo = teamLogos.logoList["\(String(describing: homeID!))"]
        let awayTeamLogo = teamLogos.logoList["\(String(describing: awayID!))"]

        self.homeTeamLogo.image = UIImage(named: "\(String(describing: homeTeamLogo!)).png")
        self.awayTeamLogo.image = UIImage(named: "\(String(describing: awayTeamLogo!)).png")
    }


    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowLineUps" {
//            if let vc = segue.destination as? LineUpsViewController {
//                vc.test = "Test"
//            }
//        }
//    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if identifier == "ShowLineUps" {
//            if homeTeamStatsDict.count > 0 {
//                return true
//            }
//        }
//        return false
//    }

}
