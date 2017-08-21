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
        matchEventsTableView.layoutIfNeeded()
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
    
    func resetConstraints(cell: EventTableViewCell) {
        cell.dividerViewBottomConstraint.constant = -8.0
        cell.dividerViewTopConstraint.constant = -8.0
    }
    
    func resetLabels(cell: EventTableViewCell,isHome: Bool) {
        if isHome {
            cell.homeEventDescription.isHidden = false
            cell.homeEventTime.isHidden = false
            cell.awayEventDescription.isHidden = true
            cell.awayEventTime.isHidden = true
        } else {
            cell.homeEventDescription.isHidden = true
            cell.homeEventTime.isHidden = true
            cell.awayEventDescription.isHidden = false
            cell.awayEventTime.isHidden = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchEventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchEventCell", for: indexPath) as! EventTableViewCell
        
        let event = String(describing: matchEventsArray[indexPath.row].type!)
        let when = String(describing: matchEventsArray[indexPath.row].when!)
        
        switch event {
        case event where event == "kickoff" || event == "halftime" || event == "fulltime":
            cell.eventImage.image = UIImage(named: "\(event).png")
            cell.homeEventDescription.isHidden = true
            cell.homeEventTime.isHidden = true
            cell.awayEventDescription.isHidden = true
            cell.awayEventTime.isHidden = true
            if event == "kickoff" {
                cell.dividerViewTopConstraint.constant = cell.bounds.height / 2
            } else if event == "fulltime" {
                cell.dividerViewBottomConstraint.constant = cell.bounds.height / 2
            } else {
                resetConstraints(cell: cell)
            }
        case "substitution":
            cell.eventImage.image = UIImage(named: "\(event).png")
            if matchEventsArray[indexPath.row].isHome! {
                cell.homeEventDescription.text = "\(matchEventsArray[indexPath.row].subOff!) off \n\(matchEventsArray[indexPath.row].subOn!) on"
                cell.homeEventTime.text = when
                resetLabels(cell: cell, isHome: true)
            } else {
                cell.awayEventDescription.text = "\(matchEventsArray[indexPath.row].subOff!) off\n\(matchEventsArray[indexPath.row].subOn!) on"
                cell.awayEventTime.text = when
                resetLabels(cell: cell, isHome: false)
            }
            resetConstraints(cell: cell)
        default:
            cell.eventImage.image = UIImage(named: "\(event).png")
            if matchEventsArray[indexPath.row].isHome! {
                cell.homeEventDescription.text = "\(event.uppercaseFirst) - \(String(describing: matchEventsArray[indexPath.row].whom!))"
                cell.homeEventTime.text = when
                resetLabels(cell: cell, isHome: true)
            } else {
                cell.awayEventDescription.text = "\(event.uppercaseFirst) - \(String(describing: matchEventsArray[indexPath.row].whom!))"
                cell.awayEventTime.text = when
                resetLabels(cell: cell, isHome: false)
            }
            resetConstraints(cell: cell)
        }
        return cell
    }
}

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
}
