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
    
    let sectionHeaders = ["Half Time Score","Posession","Shots","Shots on Target","Corners","Fouls","Yellow Cards","Red Cards"]
    
    var homeTeamStatsArray = [Double]()
    var awayTeamStatsArray = [Double]()
    
    var homeWidthConstraint: NSLayoutConstraint?
    var awayWidthConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchStatsTableView.isHidden = true
        getMatchStatsData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            
            if let homeTeamStats = json["homeStats"] as? NSDictionary {
                
                for (_, value) in homeTeamStats {
                    homeTeamStatsArray.append(value as! Double)
                }
                
//                if let homeTeamStats = homeTeamStats["halfTimeScore"] as? String {
//                    homeTeamStats
//
//                }
                
                //performSegue(withIdentifier: "ShowMatchStatsBars", sender: Any?.self)
            }
            
            if let awayTeamStats = json["awayStats"] as? NSDictionary {
                
                for (_, value) in awayTeamStats {
                    awayTeamStatsArray.append(value as! Double)
                }
                
//                if let awayTeamStatsArray = awayTeamStats["halfTimeScore"] as? NSArray {
//
//                }
                
                //createPercentages(homeInput: homeTeamStatsDict["halfTimeScore"] as! Double, awayInput: awayTeamStats["halfTimeScore"])
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
            matchStatsTableView.reloadData()
            matchStatsTableView.isHidden = false
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
    
    func createPercentages(homeInput: Double, awayInput: Double) -> (home: CGFloat, away: CGFloat) {
            
//        if let homeHalfTimeScore = homeTeamStatsDict["halfTimeScore"] {
//            print(homeHalfTimeScore)
//        }
        
        // BUGS HERE
        let sum = homeInput + awayInput
        var home: Double?
        var away: Double?
        
        if homeInput != 0.0 {
            home = homeInput / sum
        } else {
            home = 0.0
        }
        
        if awayInput != 0.0 {
            away = awayInput / sum
        } else {
            away = 0.0
        }
        
        return (CGFloat(home!), CGFloat(away!))
    }
    
    // MARK: - TableView methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchStatsCell", for: indexPath) as! MatchStatsTableViewCell
        
        
        homeWidthConstraint = cell.homePosessionView.widthAnchor.constraint(equalToConstant: matchStatsTableView.frame.width * 0.5)
        homeWidthConstraint!.isActive = true
        
        awayWidthConstraint = cell.awayPosessionView.widthAnchor.constraint(equalToConstant: matchStatsTableView.frame.width * 0.5)
        awayWidthConstraint!.isActive = true
        
        if homeTeamStatsArray.count != 0 && awayTeamStatsArray.count != 0 {
        let percentages = createPercentages(homeInput: homeTeamStatsArray[indexPath.section], awayInput: awayTeamStatsArray[indexPath.section])
            
//            if percentages.home > 0 {
                homeWidthConstraint?.constant = matchStatsTableView.frame.width * percentages.home
//            } else {
//                homeWidthConstraint?.constant = matchStatsTableView.frame.width * 0.5
//            }
            
//            if percentages.away > 0 {
                awayWidthConstraint?.constant = matchStatsTableView.frame.width * percentages.away
//            } else {
//                awayWidthConstraint?.constant = matchStatsTableView.frame.width * 0.5
//            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 35.0
        } else {
            return 15.0
        }
    }
    
    // Custom section header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let headerView = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height: 50)))
        
        var y = -10
        if section == 0 {
            y = 8
        }
        
        let label = UILabel(frame: CGRect(x: -15, y: y, width: Int(self.view.frame.width), height: 20))
        label.text = sectionHeaders[section]
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightBold)
        label.textAlignment = .center
        headerView.addSubview(label)
        
        return headerView
    }
}
