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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(LineUpsViewController.lineUpMatchData), name: NSNotification.Name(rawValue: matchDataNCKey), object: nil)
        lineUpTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func lineUpMatchData() {
        
        if let homeTeam = MatchJSONData.sharedInstance.homeTeamPlayers as? NSArray {
                for i in 0..<numStartingPlayers {
                    if let lineUpData = homeTeam[i] as? NSDictionary {
                        let newPlayer = StartingPlayer()
                        newPlayer.playerName = lineUpData["name"] as? String
                        newPlayer.playerNumber = lineUpData["number"] as? Int
                        newPlayer.formationPlace = lineUpData["formationPlace"] as? Int
                        newPlayer.isHomePlayer = true
                        startingPlayers.append(newPlayer)
                    }
                }
                for i in numStartingPlayers..<homeTeam.count {
                    if let lineUpData = homeTeam[i] as? NSDictionary {
                        let newBenchPlayer = BenchPlayer()
                        newBenchPlayer.playerName = lineUpData["name"] as? String
                        newBenchPlayer.playerNumber = lineUpData["number"] as? Int
                        newBenchPlayer.isHomePlayer = true
                        benchPlayers.append(newBenchPlayer)
                    }
                }
            }
        
        if let awayTeam = MatchJSONData.sharedInstance.awayTeamPlayers as? NSArray {
            for i in 0..<numStartingPlayers {
                if let lineUpData = awayTeam[i] as? NSDictionary {
                    let newPlayer = StartingPlayer()
                    newPlayer.playerName = lineUpData["name"] as? String
                    newPlayer.playerNumber = lineUpData["number"] as? Int
                    newPlayer.formationPlace = lineUpData["formationPlace"] as? Int
                    newPlayer.isHomePlayer = false
                    
                    startingPlayers.append(newPlayer)
                }
            }
            for i in numStartingPlayers..<awayTeam.count {
                if let lineUpData = awayTeam[i] as? NSDictionary {
                    let newBenchPlayer = BenchPlayer()
                    newBenchPlayer.playerName = lineUpData["name"] as? String
                    newBenchPlayer.playerNumber = lineUpData["number"] as? Int
                    newBenchPlayer.isHomePlayer = false
                    
                    benchPlayers.append(newBenchPlayer)
                }
            }
        }
        // Reload view once all JSON data is loaded
        lineUpTableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return numStartingPlayers
        } else {
            return benchPlayers.count / 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineUpCell") as! LineUpsTableViewCell
        
        if !startingPlayers.isEmpty {
            if indexPath.section == 0 {
                cell.homePlayerNameLabel.text = startingPlayers[indexPath.row].playerName
                cell.homePlayerNumberLabel.text = String(describing: startingPlayers[indexPath.row].playerNumber!)
                cell.awayPlayerNameLabel.text = startingPlayers[indexPath.row + 11].playerName
                cell.awayPlayerNumberLabel.text = String(describing: startingPlayers[indexPath.row + 11].playerNumber!)
            } else {
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
