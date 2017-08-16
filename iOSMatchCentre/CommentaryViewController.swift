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
    
    var eventTypes = [String]()
    var eventTimes = [String]()
    var eventHeadings = [String]()
    var eventDescriptions = [String]()
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup table view cell heights
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // Notification observer for when json data is successfully loaded
        NotificationCenter.default.addObserver(self, selector: #selector(CommentaryViewController.populateData), name: NSNotification.Name(rawValue: commentaryDataNCKey), object: nil)
        
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
                if let matchEvent = commentaryData[i] as? NSDictionary {
                    eventTypes.append(matchEvent["type"] as! String)
                    eventTimes.append(matchEvent["time"] as! String)
                    eventHeadings.append(matchEvent["heading"] as! String)
                    eventDescriptions.append(matchEvent["description"] as! String)
                }
            }
        }
        // Reload tableView data once all JSON data is loaded
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    
    // MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventDescriptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //eventDescriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentaryCell", for: indexPath) as! CommentaryTableViewCell
        cell.commentaryLabel?.text = eventDescriptions[indexPath.section]
        //cell.layoutMargins.top = 10.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventTimes[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if eventTimes[section] == "" {
            return 8.0
        } else {
            return 20.0
        }
    }
}
