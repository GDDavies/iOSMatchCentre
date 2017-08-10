//
//  ViewController.swift
//  iOSMatchCentre
//
//  Created by George Davies on 10/08/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var containerViewA: UIView!
    @IBOutlet weak var containerViewB: UIView!
    
    @IBAction func segmentedController(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewA.alpha = 0
                self.containerViewB.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewA.alpha = 1
                self.containerViewB.alpha = 0
            })
        }
    }
    
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
                }
            }
            
        } catch {
            // Error popup
            print("Error fetching data")
        }
    }
}

