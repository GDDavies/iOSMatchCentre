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
    
    var homePlayerName = [String?]()
    var homePlayerNumber = [Int?]()
    var homeFormationPlace = [Int?]()
    
    var homeSubPlayerName = [String?]()
    var homeSubPlayerNumber = [Int?]()
    
    var awayPlayerName = [String?]()
    var awayPlayerNumber = [Int?]()
    var awayFormationPlace = [Int?]()
    
    var awaySubPlayerName = [String?]()
    var awaySubPlayerNumber = [Int?]()
    
    let sectionHeaders = ["Starting XI","Substitutes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMatchLineUpsData()
        //lineUpTableView.estimatedRowHeight = 30.0
        lineUpTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Retreive all match stats data from JSON feed
    func getMatchLineUpsData() {
        let url = URL(string: "https://feeds.tribehive.co.uk/DigitalStadiumServer/opta?pageType=match&value=803294&v=5")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data {
                    // If successful pass data object to populate function
                    self.lineUpMatchData(unwrappedData)
                } else {
                    // Error popup
                    print("Unable to retrieve data")
                }
            })
        })
        task.resume()
    }
    
    func lineUpMatchData(_ matchLineUpData: Data) {
        do {
            // Create diciotnary from JSON data object
            let json = try JSONSerialization.jsonObject(with: matchLineUpData, options: []) as! NSDictionary
            
            if let homeTeam = json["home"] as? NSDictionary {
                if let team = homeTeam["team"] as? NSArray {
                        for i in 0..<10 {
                            if let lineUpData = team[i] as? NSDictionary {
                                let name = lineUpData["name"] as? String
                                let number = lineUpData["number"] as? Int
                                let place = lineUpData["formationPlace"] as? Int

                                homePlayerName.append(name)
                                homePlayerNumber.append(number)
                                homeFormationPlace.append(place)
                            }
                        }
                        for i in 11..<team.count {
                            if let lineUpData = team[i] as? NSDictionary {
                                let name = lineUpData["name"] as? String
                                let number = lineUpData["number"] as? Int
                                
                                homeSubPlayerName.append(name)
                                homeSubPlayerNumber.append(number)
                            }
                        }
                    }
                }
            
            if let awayTeam = json["away"] as? NSDictionary {
                if let team = awayTeam["team"] as? NSArray {
                    for i in 0..<10 {
                        if let lineUpData = team[i] as? NSDictionary {
                            let name = lineUpData["name"] as? String
                            let number = lineUpData["number"] as? Int
                            let place = lineUpData["formationPlace"] as? Int
                            
                            awayPlayerName.append(name)
                            awayPlayerNumber.append(number)
                            awayFormationPlace.append(place)
                        }
                    }
                    for i in 11..<team.count {
                        if let lineUpData = team[i] as? NSDictionary {
                            let name = lineUpData["name"] as? String
                            let number = lineUpData["number"] as? Int
                            
                            awaySubPlayerName.append(name)
                            awaySubPlayerNumber.append(number)
                        }
                    }
                }
            }


            // Reload view once all JSON data is loaded
            lineUpTableView.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return homePlayerName.count
        } else {
            return homeSubPlayerName.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineUpCell") as! LineUpsTableViewCell
        
        if indexPath.section == 0 {
            cell.homePlayerNameLabel.text = homePlayerName[indexPath.row]
            cell.homePlayerNumberLabel.text = String(describing: homePlayerNumber[indexPath.row]!)
            cell.awayPlayerNameLabel.text = awayPlayerName[indexPath.row]
            cell.awayPlayerNumberLabel.text = String(describing: awayPlayerNumber[indexPath.row]!)
        } else {
            cell.homePlayerNameLabel.text = homeSubPlayerName[indexPath.row]
            cell.homePlayerNumberLabel.text = String(describing: homeSubPlayerNumber[indexPath.row]!)
            cell.awayPlayerNameLabel.text = awaySubPlayerName[indexPath.row]
            cell.awayPlayerNumberLabel.text = String(describing: awaySubPlayerNumber[indexPath.row]!)
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
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightBold)
        label.textAlignment = .center
        headerView.addSubview(label)
        
        return headerView
    }
}
