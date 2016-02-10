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
    
    let presenter:Presenter = Presenter();
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    
    //MARK : Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender === importMindmap) {
            let mindmapId = mindmapIdTextField.text;
            
            //Show loader
            progressBarDisplayer("Loading Mindmap", true)
            
            if(!presenter.connectToServer(mindmapId!)) {
                print("Network Error")
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.messageFrame.removeFromSuperview()
            }
            
        }
    }
}
