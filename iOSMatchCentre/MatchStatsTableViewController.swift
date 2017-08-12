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
    
    let sectionHeaders = ["Half Time Score","Possession","Shots","Shots on Target","Corners","Fouls","Yellow Cards","Red Cards"]
    
    var homeTeamStatsArray = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    var awayTeamStatsArray = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    
    var homeStatsWidthArray: [CGFloat] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]

        
    override func viewDidLoad() {
        super.viewDidLoad()
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
                
                for (key, value) in homeTeamStats {
                    
                    switch key as! String {
                    case "halfTimeScore":
                        homeTeamStatsArray[0] = value as! Double
                    case "possession":
                        homeTeamStatsArray[1] = value as! Double
                    case "shots":
                        homeTeamStatsArray[2] = value as! Double
                    case "shotsOnTarget":
                        homeTeamStatsArray[3] = value as! Double
                    case "corners":
                        homeTeamStatsArray[4] = value as! Double
                    case "fouls":
                        homeTeamStatsArray[5] = value as! Double
                    case "yellowCards":
                        homeTeamStatsArray[6] = value as! Double
                    case "redCards":
                        homeTeamStatsArray[7] = value as! Double
                    default:
                        print("error")
                    }
                }
            }
            
            if let awayTeamStats = json["awayStats"] as? NSDictionary {
                
                for (key, value) in awayTeamStats {
                    
                    switch key as! String {
                    case "halfTimeScore":
                        awayTeamStatsArray[0] = value as! Double
                    case "possession":
                        awayTeamStatsArray[1] = value as! Double
                    case "shots":
                        awayTeamStatsArray[2] = value as! Double
                    case "shotsOnTarget":
                        awayTeamStatsArray[3] = value as! Double
                    case "corners":
                        awayTeamStatsArray[4] = value as! Double
                    case "fouls":
                        awayTeamStatsArray[5] = value as! Double
                    case "yellowCards":
                        awayTeamStatsArray[6] = value as! Double
                    case "redCards":
                        awayTeamStatsArray[7] = value as! Double
                    default:
                        print("error")
                    }
                }
            }
            
            // Reload view once all JSON data is loaded
            matchStatsTableView.reloadData()
        } catch {
            // Error popup
            print("Error fetching data")
        }
    }

    /*
    // MARK: - Navigation

    */
    
    func createHomePercentage(homeInput: Double, awayInput: Double, index: Int) {
        
        let sum = homeInput + awayInput
        
        if homeInput == 0 && awayInput == 0 {
            homeStatsWidthArray.remove(at: index)
            homeStatsWidthArray.insert(CGFloat(0.5), at: index)
        } else if homeInput == 0 {
            homeStatsWidthArray.remove(at: index)
            homeStatsWidthArray.insert(CGFloat(0.0), at: index)
        } else if awayInput == 0 {
            homeStatsWidthArray.remove(at: index)
            homeStatsWidthArray.insert(CGFloat(1.0), at: index)
        } else {
            homeStatsWidthArray.remove(at: index)
            homeStatsWidthArray.insert(CGFloat(homeInput / sum), at: index)
        }
    }
    
    // MARK: - TableView methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchStatsCell", for: indexPath) as! MatchStatsTableViewCell
        
        cell.awayStatsView.backgroundColor = Theme.primaryTeamColour
        
        if homeTeamStatsArray[1] != 0.0 {
            
            let homeStatsShapeLayer = CAShapeLayer()
            let awayStatsBounds = cell.awayStatsView.bounds
            
            createHomePercentage(homeInput: homeTeamStatsArray[indexPath.section], awayInput: awayTeamStatsArray[indexPath.section], index: indexPath.section)
        
            homeStatsShapeLayer.frame = CGRect(x: awayStatsBounds.origin.x, y: awayStatsBounds.origin.y, width: awayStatsBounds.width * homeStatsWidthArray[indexPath.section], height: awayStatsBounds.height)
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            
            cell.homeStatLabel.text = formatter.string(from: NSNumber(value: homeTeamStatsArray[indexPath.section]))
            cell.awayStatLabel.text = formatter.string(from: NSNumber(value: awayTeamStatsArray[indexPath.section]))
            
            homeStatsShapeLayer.fillColor = UIColor(red: 230/255, green: 35/255, blue: 51/255, alpha: 1.0).cgColor
            homeStatsShapeLayer.path = UIBezierPath(rect: homeStatsShapeLayer.bounds).cgPath
            
            // Remove away stats view sublayer if present
            if cell.awayStatsView.layer.sublayers?.count == 1 {
                cell.awayStatsView.layer.sublayers!.remove(at: 0)
            }
            cell.awayStatsView.layer.insertSublayer(homeStatsShapeLayer, at: 0)
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
        
        let label = UILabel(frame: CGRect(x: 0, y: y, width: Int(self.view.frame.width), height: 20))
        label.text = sectionHeaders[section]
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightBold)
        label.textAlignment = .center
        headerView.addSubview(label)
        
        return headerView
    }

}
