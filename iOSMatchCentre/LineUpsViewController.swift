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
    
    var startingPlayers = [Player]()
    var benchPlayers = [Player]()
    let sectionHeaders = ["Starting XI","Substitutes"]
    let numStartingPlayers = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add notification observer for when JSON data is loaded successfully
        NotificationCenter.default.addObserver(self, selector: #selector(lineUpMatchData), name: NSNotification.Name(rawValue: matchDataNCKey), object: nil)
        lineUpTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Parse lineups from JSON and convert to array of player objects
    func lineUpMatchData() {
        
        
        
        // Get home team player array
        let homeTeam = MatchJSONData.sharedInstance.homeTeamPlayers
        // Loop through array for first 11 players
        for i in 0..<numStartingPlayers {
            // Create newPlayer object using dictionary values
            let newPlayer = returnNewPlayer(player: homeTeam[i], isHome: true, index: i)
            // Append newPlayer to array
            startingPlayers.append(newPlayer)
        }
        
        let awayTeam = MatchJSONData.sharedInstance.awayTeamPlayers
        for i in 0..<numStartingPlayers {
            let newPlayer = returnNewPlayer(player: awayTeam[i], isHome: false, index: i)
            startingPlayers.append(newPlayer)
        }
        
        // Loop through array for remaining players
        for i in numStartingPlayers..<homeTeam.count {
            // Create newBenchPlayer object using dictionary values
            let newBenchPlayer = returnNewPlayer(player: homeTeam[i], isHome: true, index: i)
            // Append newBenchPlayer to array
            benchPlayers.append(newBenchPlayer)
        }

        for i in numStartingPlayers..<awayTeam.count {
            let newBenchPlayer = returnNewPlayer(player: awayTeam[i], isHome: false, index: i)
            benchPlayers.append(newBenchPlayer)
        }
        // Reload view once all JSON data is loaded
        lineUpTableView.reloadData()
    }
    
    func returnNewPlayer(player: [String: Any], isHome: Bool, index: Int) -> Player {
        let newPlayer = Player()
        newPlayer.playerName = player["name"] as? String
        newPlayer.playerNumber = player["number"] as? Int
        newPlayer.isHomePlayer = isHome
        return newPlayer
    }
    
    func lineUpTeamCircles(cell: LineUpsTableViewCell) {
        zip([cell.homePlayerNumberLabel, cell.awayPlayerNumberLabel],[MatchJSONData.sharedInstance.homeTeamName, MatchJSONData.sharedInstance.awayTeamName]).forEach {
            if let teamName = $0.1 {
                // Apply circle with team colours if team name exists
                let cornerRadius: CGFloat = 10
                $0.0?.layer.cornerRadius = cornerRadius
                $0.0?.layer.borderWidth = 2.0
                $0.0?.layer.borderColor = TeamColours.primaryColour["\(String(describing: teamName))"]?.cgColor
                $0.0?.layer.backgroundColor = TeamColours.secondaryColour["\(String(describing: teamName))"]?.cgColor
                $0.0?.textColor = TeamColours.primaryColour["\(String(describing: teamName))"]
            }
        }
    }
    
    // One section for starting XI and one for subs
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
            
            lineUpTeamCircles(cell: cell)
            
            // Starting XI section
            if indexPath.section == 0 {
                cell.homePlayerNameLabel.text = startingPlayers[indexPath.row].playerName
                cell.homePlayerNumberLabel.text = String(describing: startingPlayers[indexPath.row].playerNumber!)

                cell.awayPlayerNameLabel.text = startingPlayers[indexPath.row + numStartingPlayers].playerName
                cell.awayPlayerNumberLabel.text = String(describing: startingPlayers[indexPath.row + numStartingPlayers].playerNumber!)
            } else {
                // Substitute section
                cell.homePlayerNameLabel.text = benchPlayers[indexPath.row].playerName
                cell.homePlayerNumberLabel.text = String(describing: benchPlayers[indexPath.row].playerNumber!)
                
                cell.awayPlayerNameLabel.text = benchPlayers[indexPath.row + (benchPlayers.count / 2)].playerName
                cell.awayPlayerNumberLabel.text = String(describing: benchPlayers[indexPath.row + (benchPlayers.count / 2)].playerNumber!)
            }
        }
        // Remove separator line edge inset
        cell.separatorInset = UIEdgeInsets.zero
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
        
        // Section header label settings
        let label = UILabel(frame: CGRect(x: 0, y: y, width: Int(self.view.frame.width), height: 20))
        label.text = sectionHeaders[section]
        label.font = UIFont(name: "DroidSans-Bold", size: 14.0)
        label.textAlignment = .center
        headerView.addSubview(label)
        
        return headerView
    }
}
