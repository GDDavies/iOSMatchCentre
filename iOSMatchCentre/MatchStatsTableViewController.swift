//
//  MatchStatsTableViewController.swift
//  iOSMatchCentre
//
//  Created by George Davies on 11/08/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

class MatchStatsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var matchStatsTableView: UITableView!
    
    let screenHeight = UIScreen.main.bounds.height
    
    var homeTeamStatsArray = [Double]()
    var awayTeamStatsArray = [Double]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MatchStatsTableViewController.populateMatchStatsData), name: NSNotification.Name(rawValue: matchDataNCKey), object: nil)
        matchStatsTableView.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateMatchStatsData() {
        
        if let homeMatchStats = MatchJSONData.sharedInstance.matchStatsJSON?["homeStats"] as? NSDictionary {
            homeTeamStatsArray = returnMatchStatsData(teamStats: homeMatchStats)
        }
        
        if let awayMatchStats = MatchJSONData.sharedInstance.matchStatsJSON?["awayStats"] as? NSDictionary {
            awayTeamStatsArray = returnMatchStatsData(teamStats: awayMatchStats)
        }
        
        // Reload view once all JSON data is loaded
        matchStatsTableView.reloadData()
    }
    
    func returnMatchStatsData(teamStats: NSDictionary) -> Array<Double> {
        var array = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        
        for (key, value) in teamStats {
            
            switch key as! String {
            case "halfTimeScore":
                array[0] = value as! Double
            case "possession":
                array[1] = value as! Double
            case "shots":
                array[2] = value as! Double
            case "shotsOnTarget":
                array[3] = value as! Double
            case "corners":
                array[4] = value as! Double
            case "fouls":
                array[5] = value as! Double
            case "yellowCards":
                array[6] = value as! Double
            case "redCards":
                array[7] = value as! Double
            default:
                print("error")
            }
        }
        return array
    }
    
    // Return width
    func createHomePercentage(homeInput: Double, awayInput: Double, index: Int) -> CGFloat {
        
        let sum = homeInput + awayInput
        var width:CGFloat = 0.0
        
        switch (homeInput, awayInput) {
        case (0, 0):
            width = 0.5
        case (0, _):
            width = 0.0
        case (_, 0):
            width = 1.0
        default:
            width = CGFloat(homeInput / sum)
        }
        return width
    }
    
    // MARK: - TableView methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchStatsCell", for: indexPath) as! MatchStatsTableViewCell
        
        // Away team colour
        if let awayName = MatchJSONData.sharedInstance.awayTeamName {
            cell.awayStatsView.backgroundColor = TeamColours.primaryColour["\(String(describing: awayName))"]
        }
        
        if !homeTeamStatsArray.isEmpty {
                
            let homeStatsShapeLayer = CAShapeLayer()
            cell.awayStatsView.layer.cornerRadius = cell.awayStatsView.frame.height / 2
            let awayStatsBounds = cell.awayStatsView.bounds
            
            // Remove decimal points from stats
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            
            let homeStatsWidth = createHomePercentage(homeInput: homeTeamStatsArray[indexPath.section], awayInput: awayTeamStatsArray[indexPath.section], index: indexPath.section)
        
            homeStatsShapeLayer.frame = CGRect(x: awayStatsBounds.origin.x, y: awayStatsBounds.origin.y, width: awayStatsBounds.width * homeStatsWidth, height: awayStatsBounds.height)
            
            cell.homeStatLabel.text = formatter.string(from: NSNumber(value: homeTeamStatsArray[indexPath.section]))
            cell.awayStatLabel.text = formatter.string(from: NSNumber(value: awayTeamStatsArray[indexPath.section]))
            
            // Home team colour
            if let homeName = MatchJSONData.sharedInstance.homeTeamName {
                homeStatsShapeLayer.fillColor = TeamColours.primaryColour["\(String(describing: homeName))"]?.cgColor
                if awayTeamStatsArray[indexPath.section] != 0 || awayTeamStatsArray[indexPath.section] == homeTeamStatsArray[indexPath.section] {
                    // Rounded corners on left side of stats bars
                    homeStatsShapeLayer.path = UIBezierPath(roundedRect: homeStatsShapeLayer.bounds, byRoundingCorners: [UIRectCorner.topLeft , UIRectCorner.bottomLeft], cornerRadii: CGSize(width: 10.0, height: 10.0)).cgPath
                } else {
                    // Rounded corners on both sides of stats bars
                    homeStatsShapeLayer.path = UIBezierPath(roundedRect: homeStatsShapeLayer.bounds, cornerRadius: cell.awayStatsView.frame.height / 2).cgPath
                }
                homeStatsShapeLayer.cornerRadius = cell.awayStatsView.frame.height / 2
            }
            
            // Remove away stats view sublayer if present
            if cell.awayStatsView.layer.sublayers?.count == 1 {
                cell.awayStatsView.layer.sublayers!.remove(at: 0)
            }
            cell.awayStatsView.layer.insertSublayer(homeStatsShapeLayer, at: 0)
        }
        return cell
    }
    
    // Set header heights
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return screenHeight * 0.035
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight * 0.05
    }
    
    // Custom section header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "StatsHeaderCell") as! CustomStatsHeaderCell
        
        headerCell.backgroundColor = UIColor(red: 240/255, green: 239/255, blue: 245/255, alpha: 1)
        switch section {
        case 0:
            headerCell.headerLabel.text =  "Half Time Score"
        case 1:
            headerCell.headerLabel.text = "Possession (%)"
        case 2:
            headerCell.headerLabel.text = "Shots"
        case 3:
            headerCell.headerLabel.text = "Shots on Target"
        case 4:
            headerCell.headerLabel.text = "Corners"
        case 5:
            headerCell.headerLabel.text = "Fouls"
        case 6:
            headerCell.headerLabel.text = "Yellow Cards"
        case 7:
            headerCell.headerLabel.text = "Red Cards"
        default:
            headerCell.headerLabel.text = ""
        }
        return headerCell
    }
}
