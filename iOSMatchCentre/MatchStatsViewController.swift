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
    @IBOutlet weak var containerViewC: UIView!
    
    var homeID: String?
    var awayID: String?
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(MatchStatsViewController.populateMatchStatsData), name: NSNotification.Name(rawValue: matchDataNCKey), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Setup Match Stats Data
    
    func populateMatchStatsData() {
        competitionNameLabel.text = MatchJSONData.sharedInstance.competition
        venueLabel.text = MatchJSONData.sharedInstance.venue
        attendanceLabel.text = MatchJSONData.sharedInstance.attendance
        refereeLabel.text = MatchJSONData.sharedInstance.referee
        homeTeamName.text = MatchJSONData.sharedInstance.homeTeamName
        awayTeamName.text = MatchJSONData.sharedInstance.awayTeamName
        homeTeamScore.text = MatchJSONData.sharedInstance.homeTeamScore
        awayTeamScore.text = MatchJSONData.sharedInstance.awayTeamScore
        
        loadLogos()
    }
    
    func loadLogos() {
        self.homeTeamLogo.image = UIImage(named: "\(String(describing: MatchJSONData.sharedInstance.homeTeamName!)).png")
        self.awayTeamLogo.image = UIImage(named: "\(String(describing: MatchJSONData.sharedInstance.awayTeamName!)).png")
    }


    // MARK: - Navigation

}
