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
        self.view.addSubview(containerViewA)
        MatchJSONData.sharedInstance.getMatchStatsData()
        NotificationCenter.default.addObserver(self, selector: #selector(MatchStatsViewController.populateMatchStatsData), name: NSNotification.Name(rawValue: matchDataNCKey), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup Match Stats Data
    
    func populateMatchStatsData() {
            
        if let competitionName = MatchJSONData.sharedInstance.matchStatsJSON?["competition"] {
            competitionNameLabel.text = String(describing: competitionName)
        }
        if let venueName = MatchJSONData.sharedInstance.matchStatsJSON?["venue"] {
            venueLabel.text = String(describing: venueName)
        }
        if let attendanceSize = MatchJSONData.sharedInstance.matchStatsJSON?["attendance"] {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            let formattedAttendance = numberFormatter.string(from: NSNumber(value:attendanceSize as! Int))
            attendanceLabel.text = "Attendance: \(formattedAttendance!)"
        }
        if let refereeName = MatchJSONData.sharedInstance.matchStatsJSON?["referee"] {
            refereeLabel.text = "Ref: " + String(describing: refereeName)
        }
        if let homeTeam = MatchJSONData.sharedInstance.matchStatsJSON?["home"] as? NSDictionary {
            if let homeTeamNameText = homeTeam["name"] {
                homeTeamName.text = String(describing: homeTeamNameText)
            }
            if let homeTeamID = homeTeam["id"] {
                homeID = String(describing: homeTeamID)
            }
        }
        if let awayTeam = MatchJSONData.sharedInstance.matchStatsJSON?["away"] as? NSDictionary {
            if let awayTeamNameText = awayTeam["name"] {
                awayTeamName.text = String(describing: awayTeamNameText)
            }
            if let awayTeamID = awayTeam["id"] {
                awayID = String(describing: awayTeamID)
            }
        }
        if let homeTeamStats = MatchJSONData.sharedInstance.matchStatsJSON?["homeStats"] as? NSDictionary {
            homeTeamStatsDict = homeTeamStats as! [String : Any]
            if let homeTeamScoreText = homeTeamStats["score"] {
                homeTeamScore.text = String(describing: homeTeamScoreText)
            }
        }
        if let awayTeamStats = MatchJSONData.sharedInstance.matchStatsJSON?["awayStats"] as? NSDictionary {
            if let awayTeamScoreText = awayTeamStats["score"] {
                awayTeamScore.text = String(describing: awayTeamScoreText)
            }
        }
        loadLogos()
    }
    
    func loadLogos() {
        let teamLogos = TeamInformation()

        let homeTeamLogo = teamLogos.logoList["\(String(describing: homeID!))"]
        let awayTeamLogo = teamLogos.logoList["\(String(describing: awayID!))"]

        self.homeTeamLogo.image = UIImage(named: "\(String(describing: homeTeamLogo!)).png")
        self.awayTeamLogo.image = UIImage(named: "\(String(describing: awayTeamLogo!)).png")
    }


    // MARK: - Navigation

}
