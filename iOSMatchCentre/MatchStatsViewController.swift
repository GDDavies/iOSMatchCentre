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
    
    @IBOutlet weak var competitionImageView: UIImageView!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var refereeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var containerViewA: UIView!
    @IBOutlet weak var containerViewC: UIView!
    @IBOutlet weak var matchEventsContainerView: UIView!
    
    @IBOutlet weak var customSegment: CustomSegmentedControl!
    
    @IBAction func customSegmentControl(_ sender: CustomSegmentedControl) {
        
        if sender.selectedButtonIndex == 0 {
            self.view.addSubview(containerViewA)
        } else if sender.selectedButtonIndex == 1 {
            self.view.addSubview(containerViewC)
        } else {
            self.view.addSubview(matchEventsContainerView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(containerViewA)
        NotificationCenter.default.addObserver(self, selector: #selector(MatchStatsViewController.populateMatchStatsData), name: NSNotification.Name(rawValue: matchDataNCKey), object: nil)
        
        customSegment.buttonTitles = ["Stats","Line Ups","Events"]
        customSegment.backgroundColor = Theme.primaryTeamColour
        customSegment.selector.backgroundColor = UIColor(red: 240/255, green: 239/255, blue: 245/255, alpha: 1)
        customSegment.newTextColour = UIColor.white
        //customSegment.updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Setup Match Stats Data
    func populateMatchStatsData() {
        venueLabel.text = MatchJSONData.sharedInstance.venue
        attendanceLabel.text = MatchJSONData.sharedInstance.attendance
        refereeLabel.text = MatchJSONData.sharedInstance.referee
        dateLabel.text = MatchJSONData.sharedInstance.date
        homeTeamName.text = MatchJSONData.sharedInstance.homeTeamName
        awayTeamName.text = MatchJSONData.sharedInstance.awayTeamName
        homeTeamScore.text = MatchJSONData.sharedInstance.homeTeamScore
        awayTeamScore.text = MatchJSONData.sharedInstance.awayTeamScore
        
        loadLogos()
    }
    
    func loadLogos() {
        
        if let homeTeam = MatchJSONData.sharedInstance.homeTeamName {
            if let homeLogo = UIImage(named: "\(String(describing: homeTeam)).png") {
                self.homeTeamLogo.image = homeLogo
            }
        }
        
        if let awayTeam = MatchJSONData.sharedInstance.awayTeamName {
            if let awayLogo = UIImage(named: "\(String(describing: awayTeam)).png") {
                self.awayTeamLogo.image = awayLogo
            }
        }
        
        if let competition = MatchJSONData.sharedInstance.competition {
            if let competitionLogo = UIImage(named: "\(String(describing: competition)).png") {
                self.competitionImageView.image = competitionLogo
            }
        }
    }
}
