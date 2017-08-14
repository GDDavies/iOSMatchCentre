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
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    @IBAction func segmentedController(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.bringContainerViewAToFront()
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.bringContainerViewBToFront()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.bringContainerViewAToFront()
        
        navigationController?.navigationBar.barTintColor = Theme.primaryTeamColour
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Theme.secondaryTeamColour]
        segmentController.tintColor = Theme.secondaryTeamColour
        segmentController.backgroundColor = Theme.primaryTeamColour
        
        MatchJSONData.sharedInstance.getMatchStatsData()
        CommentaryJSONData.sharedInstance.getMatchCommentaryData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bringContainerViewAToFront() {
        self.containerViewA.alpha = 1
        self.containerViewB.alpha = 0
    }
    
    func bringContainerViewBToFront() {
        self.containerViewB.alpha = 1
        self.containerViewA.alpha = 0
    }
}

