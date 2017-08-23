//
//  CommentaryViewController.swift
//  iOSMatchCentre
//
//  Created by George Davies on 10/08/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

class CommentaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var matchEvents = [CommentaryEvent]()
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup table view cell heights
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // Notification observer for when json data is successfully loaded
        NotificationCenter.default.addObserver(self, selector: #selector(populateData), name: NSNotification.Name(rawValue: commentaryDataNCKey), object: nil)
        
        // Refresh control to update data
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refreshData() {
        CommentaryJSONData.sharedInstance.getMatchCommentaryData()
        tableView.reloadData()
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup Commentary Data
    func populateData() {
        if let commentaryData = CommentaryJSONData.sharedInstance.commentaryJSON {
            // Loop through array and assign each value to array
            for i in 0..<commentaryData.count {
                if let commentaryEvent = commentaryData[i] as? NSDictionary {
                    let newCommentaryEvents = CommentaryEvent()
                    newCommentaryEvents.eventType = commentaryEvent["type"] as? String
                    newCommentaryEvents.eventTime = commentaryEvent["time"] as? String
                    newCommentaryEvents.eventHeading = commentaryEvent["heading"] as? String
                    newCommentaryEvents.eventDescription = commentaryEvent["description"] as? String
                    
                    matchEvents.append(newCommentaryEvents)
                }
            }
        }
        // Reload tableView data once all JSON data is loaded
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    
    // MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return matchEvents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //eventDescriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentaryCell", for: indexPath) as! CommentaryTableViewCell
        cell.commentaryLabel?.text = matchEvents[indexPath.section].eventDescription
        //cell.layoutMargins.top = 10.0
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return eventTimes[section]
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if matchEvents[section].eventTime == "" {
            return 8.0
        } else {
            return 15.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height: 20)))
        var y = -10
        if section == 0 {
            y = 8
        }
        let label = UILabel(frame: CGRect(x: 10, y: y, width: Int(self.view.frame.width), height: 20))
        label.text = matchEvents[section].eventTime
        label.font = UIFont(name: "DroidSans-Bold", size: 14.0)
        label.textAlignment = .left
        headerView.addSubview(label)
        
        return headerView
    }
}
