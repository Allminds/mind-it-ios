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
    
    //MARK : Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //Default Id
        mindmapIdTextField.text = Config.MINDMAPID
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender === importMindmap) {
            let mindmapId = mindmapIdTextField.text;
            
            let tableViewController = segue.destinationViewController as! MindmapTableViewController;
            tableViewController.mindmapId = mindmapId
        }
    }
}
