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
    
    var loadingOverlay: UIView?
    var loadingDataIndicator: UIActivityIndicatorView?
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.removeOverlay), name: NSNotification.Name(rawValue: matchDataNCKey), object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.bringContainerViewAToFront()
        
        navigationController?.navigationBar.barTintColor = Theme.primaryTeamColour
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Theme.secondaryTeamColour]
        segmentController.tintColor = Theme.secondaryTeamColour
        segmentController.backgroundColor = Theme.primaryTeamColour
        
        MatchJSONData.sharedInstance.getMatchStatsData()
        CommentaryJSONData.sharedInstance.getMatchCommentaryData()
        
        addOverlay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addOverlay() {
        
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
        loadingDataIndicator = UIActivityIndicatorView(frame: view.frame)
        loadingDataIndicator?.color = UIColor.black
        
        loadingDataIndicator?.center = CGPoint(x: w / 2, y: h / 2)
        
        loadingDataIndicator?.startAnimating()
        
        
        loadingOverlay = UIView(frame: view.frame)
        loadingOverlay?.backgroundColor = UIColor.white
        
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
//        label.numberOfLines = 0
//        label.text = "Loading Data - Please wait..."
//        label.center = CGPoint(x: w / 2, y: h / 2)
//        label.textAlignment = NSTextAlignment.center

        loadingOverlay?.addSubview(loadingDataIndicator!)
        
        loadingOverlay?.alpha = 1.0
        view.addSubview(loadingOverlay!)
    }
    
    func removeOverlay() {
        loadingDataIndicator?.stopAnimating()
        loadingDataIndicator?.removeFromSuperview()
        loadingOverlay?.removeFromSuperview()
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

