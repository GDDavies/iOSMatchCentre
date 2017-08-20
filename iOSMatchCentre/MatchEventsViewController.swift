//
//  MatchEventsViewController.swift
//  iOSMatchCentre
//
//  Created by George Davies on 19/08/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

class MatchEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var matchEventsArray = [MatchEvent]()
    @IBOutlet weak var matchEventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MatchEventsViewController.getMatchEventsData), name: NSNotification.Name(rawValue: matchDataNCKey), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMatchEventsData() {
        for event in MatchJSONData.sharedInstance.matchEventsArray {
            let newEvent = MatchEvent()
            newEvent.type = event?["type"] as? String
            newEvent.when = event?["when"] as? String
            newEvent.whom = event?["whom"] as? String
            newEvent.isHome = event?["isHome"] as? Bool
            newEvent.subOn = event?["subOn"] as? String
            newEvent.subOff = event?["subOff"] as? String
            matchEventsArray.append(newEvent)
        }
        matchEventsTableView.reloadData()
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(matchEventsArray.count)
        return matchEventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchEventCell", for: indexPath) as! EventTableViewCell
        
        if indexPath.row == 0 {
            cell.eventImage.image = UIImage(named: "whistle.png")
            cell.dividerViewTopConstraint.constant = cell.bounds.height / 2
        } else if indexPath.row == matchEventsArray.count - 1 {
            cell.eventImage.image = UIImage(named: "whistle.png")
            cell.dividerViewBottomConstraint.constant = cell.bounds.height / 2
        } else {
            if let isHomeEvent = matchEventsArray[indexPath.row].isHome {
                if isHomeEvent {
                    cell.eventImage.image = UIImage(named: "\(String(describing: matchEventsArray[indexPath.row].type)).png")
                    cell.homeEventTime.text = matchEventsArray[indexPath.row].when
                    cell.homeEventDescription.text = matchEventsArray[indexPath.row].type
                }
            }
        }
//        
//        switch indexPath.row {
//        case 0:
//            cell.eventImage.image = UIImage(named: "goal.png")
//            cell.homeEventTime.text = "90'"
//            cell.homeEventDescription.text = "Goal! Billy Sharp"
//            cell.awayEventTime.isHidden = true
//            cell.awayEventDescription.isHidden = true
//            cell.dividerViewTopConstraint.constant = cell.bounds.height / 2
//        case 1:
//            cell.eventImage.image = UIImage(named: "substitution.png")
//            cell.awayEventTime.text = "80'"
//            cell.awayEventDescription.text = "Substitution. Billy Sharp for Ched Evans"
//            cell.homeEventTime.isHidden = true
//            cell.homeEventDescription.isHidden = true
//        case 2:
//            cell.eventImage.image = UIImage(named: "whistle.png")
//            cell.homeEventTime.text = "40'"
//            cell.homeEventDescription.text = "Foul"
//            cell.awayEventTime.isHidden = true
//            cell.awayEventDescription.isHidden = true
//        case 3:
//            cell.eventImage.image = UIImage(named: "booking.png")
//            cell.awayEventTime.text = "55'"
//            cell.awayEventDescription.text = "Booking. Paddy Kenny"
//            cell.homeEventTime.isHidden = true
//            cell.homeEventDescription.isHidden = true
//            cell.dividerViewBottomConstraint.constant = cell.bounds.height / 2
//        default:
//            cell.eventImage.image = UIImage(named: "goal.png")
//        }
        //cell.dividerView.layoutIfNeeded()
        return cell
    }
}
