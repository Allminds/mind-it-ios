//
//  HomeViewController.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK : Properties
    @IBOutlet weak var importMindmap: UIButton!
    @IBOutlet weak var mindmapIdTextField: UITextField!
    
    var mindmapId:String?;
    
    //MARK : Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender === importMindmap) {
            let mindmapId = mindmapIdTextField.text;
            self.mindmapId = mindmapId;
            
            let tracker = MeteorTracker.getInstance()
            tracker.connectToServer(self.mindmapId!)
        }
    }
}
