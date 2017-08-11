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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getData()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        let url = URL(string: "https://feeds.tribehive.co.uk/DigitalStadiumServer/opta?pageType=matchCommentary&value=803294&v=2")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data {
                    self.populateData(unwrappedData)
                } else {
                    // Error popup
                    print("Unable to retrieve data")
                }
            })
        })
        task.resume()
    }
    
    func populateData(_ matchCommentaryData: Data) {
        do {
            // Retrieve array of dictionaries
            let json = try JSONSerialization.jsonObject(with: matchCommentaryData, options: []) as! NSArray
            
            // Loop through array and assign each value to array
            for i in 0..<json.count {
                if let matchEvent = json[i] as? NSDictionary {
                    eventTypes.append(matchEvent["type"] as! String)
                    eventTimes.append(matchEvent["time"] as! String)
                    eventHeadings.append(matchEvent["heading"] as! String)
                    eventDescriptions.append(matchEvent["description"] as! String)
                }
            }
            // Reload tableView data once all JSON data is loaded
            tableView.reloadData()
        } catch {
            // Error popup
            print("Error fetching data")
        }
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 1.0
//    }
}
