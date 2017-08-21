//
//  LineUpsViewController.swift
//  iOSMatchCentre
//
//  Created by George Davies on 12/08/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

class LineUpsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lineUpTableView: UITableView!
    
    var startingPlayers = [StartingPlayer]()
    var benchPlayers = [BenchPlayer]()
    let sectionHeaders = ["Starting XI","Substitutes"]
    let numStartingPlayers = 11
    
    var homeTeamPrimaryColour: CGColor?
    var homeTeamSecondaryColour: CGColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add notification observer for when JSON data is loaded successfully
        NotificationCenter.default.addObserver(self, selector: #selector(LineUpsViewController.lineUpMatchData), name: NSNotification.Name(rawValue: matchDataNCKey), object: nil)
        lineUpTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Parse lineups from JSON and convert to array of player objects
    func lineUpMatchData() {
        let homeTeam = MatchJSONData.sharedInstance.homeTeamPlayers
        for i in 0..<numStartingPlayers {
            let lineUpData = homeTeam[i]
            let newPlayer = StartingPlayer()
            newPlayer.playerName = lineUpData["name"] as? String
            newPlayer.playerNumber = lineUpData["number"] as? Int
            newPlayer.playerPosition = lineUpData["position"] as? String
            newPlayer.formationPlace = lineUpData["formationPlace"] as? Int
            newPlayer.isHomePlayer = true
            startingPlayers.append(newPlayer)
        }
        for i in numStartingPlayers..<homeTeam.count {
            let lineUpData = homeTeam[i]
            let newBenchPlayer = BenchPlayer()
            newBenchPlayer.playerName = lineUpData["name"] as? String
            newBenchPlayer.playerNumber = lineUpData["number"] as? Int
            newBenchPlayer.isHomePlayer = true
            benchPlayers.append(newBenchPlayer)
        }
        let awayTeam = MatchJSONData.sharedInstance.awayTeamPlayers
        for i in 0..<numStartingPlayers {
            let lineUpData = awayTeam[i]
            let newPlayer = StartingPlayer()
            newPlayer.playerName = lineUpData["name"] as? String
            newPlayer.playerNumber = lineUpData["number"] as? Int
            newPlayer.playerPosition = lineUpData["position"] as? String
            newPlayer.formationPlace = lineUpData["formationPlace"] as? Int
            newPlayer.isHomePlayer = false
            startingPlayers.append(newPlayer)
        }
        for i in numStartingPlayers..<awayTeam.count {
            let lineUpData = awayTeam[i]
            let newBenchPlayer = BenchPlayer()
            newBenchPlayer.playerName = lineUpData["name"] as? String
            newBenchPlayer.playerNumber = lineUpData["number"] as? Int
            newBenchPlayer.isHomePlayer = false
            benchPlayers.append(newBenchPlayer)
        }        
        // Reload view once all JSON data is loaded
        lineUpTableView.reloadData()
    }
    
    func lineUpTeamCircles(label: UILabel) {
        
    }
    
    // Two sections, one for starting XI and one for subs
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Will return 11
            return numStartingPlayers
        } else {
            // Will return the total number of subs on both teams divided by 2
            return benchPlayers.count / 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineUpCell") as! LineUpsTableViewCell
        
        // If there are players in the startingPlayers array
        if !startingPlayers.isEmpty {
            
            let size: CGFloat = 20
            
            cell.homePlayerNumberLabel.layer.cornerRadius = size / 2
            cell.homePlayerNumberLabel.layer.borderWidth = 2.0
            cell.homePlayerNumberLabel.layer.borderColor = TeamColours.primaryColour["\(String(describing: MatchJSONData.sharedInstance.homeTeamName!))"]?.cgColor
            cell.homePlayerNumberLabel.layer.backgroundColor = TeamColours.secondaryColour["\(String(describing: MatchJSONData.sharedInstance.homeTeamName!))"]?.cgColor
            cell.homePlayerNumberLabel.textColor = TeamColours.primaryColour["\(String(describing: MatchJSONData.sharedInstance.homeTeamName!))"]
            
            cell.awayPlayerNumberLabel.layer.cornerRadius = size / 2
            cell.awayPlayerNumberLabel.layer.borderWidth = 2.0
            cell.awayPlayerNumberLabel.layer.borderColor = TeamColours.primaryColour["\(String(describing: MatchJSONData.sharedInstance.awayTeamName!))"]?.cgColor
            cell.awayPlayerNumberLabel.layer.backgroundColor = TeamColours.secondaryColour["\(String(describing: MatchJSONData.sharedInstance.awayTeamName!))"]?.cgColor
            cell.awayPlayerNumberLabel.textColor = TeamColours.primaryColour["\(String(describing: MatchJSONData.sharedInstance.awayTeamName!))"]
            
            // Starting XI section
            if indexPath.section == 0 {
                cell.homePlayerNameLabel.text = startingPlayers[indexPath.row].playerName
                cell.homePlayerNumberLabel.text = String(describing: startingPlayers[indexPath.row].playerNumber!)

                cell.awayPlayerNumberLabel.text = String(describing: startingPlayers[indexPath.row + 11].playerNumber!)
                cell.awayPlayerNameLabel.text = startingPlayers[indexPath.row + 11].playerName
                
                
            } else {
                // Substitute section
                cell.homePlayerNameLabel.text = benchPlayers[indexPath.row].playerName
                cell.homePlayerNumberLabel.text = String(describing: benchPlayers[indexPath.row].playerNumber!)
                
                cell.awayPlayerNameLabel.text = benchPlayers[indexPath.row + (benchPlayers.count / 2)].playerName
                cell.awayPlayerNumberLabel.text = String(describing: benchPlayers[indexPath.row + (benchPlayers.count / 2)].playerNumber!)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Starting 11"
        }else{
            return "Substitutes"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    // Custom section header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 35.0
        } else {
            return 15.0
        }
    }
    
    // Customise section headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height: 50)))
        
        var y = -10
        if section == 0 {
            y = 8
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: y, width: Int(self.view.frame.width), height: 20))
        label.text = sectionHeaders[section]
        label.font = UIFont(name: "DroidSans-Bold", size: 14.0)
        label.textAlignment = .center
        headerView.addSubview(label)
        
        return headerView
    }
}
