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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        let url = URL(string: "https://feeds.tribehive.co.uk/DigitalStadiumServer/opta?pageType=matchCommentary&value=803294&v=2")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                self.populateData(data!)
            })
        })
        task.resume()
    }
    
    func populateData(_ matchCommentaryData: Data) {
        
        do {
            let json = try JSONSerialization.jsonObject(with: matchCommentaryData, options: []) as! NSArray
            
            for i in 0..<json.count {
                if let matchEvent = json[i] as? NSDictionary {
                    print(matchEvent["type"] as! String)
                    print(matchEvent["time"] as! String)
                    print(matchEvent["heading"] as! String)
                    print(matchEvent["description"] as! String)
                    
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventDescriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentaryCell", for: indexPath)
        cell.textLabel?.text = eventTimes[indexPath.row] + " " + eventDescriptions[indexPath.row]
        return cell
    }
}
