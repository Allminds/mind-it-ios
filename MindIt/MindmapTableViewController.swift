//
//  MindmapTableViewController.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 08/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import UIKit
import SwiftDDP

class MindmapTableViewController: UITableViewController , PresenterDelegate {
    
    //MARK:Properties
    var messageFrame: UIView!
    var activityIndicator : UIActivityIndicatorView!
    var strLabel : UILabel!
    

    var presenter: TableViewPresenter!
    var mindmapId: String!
    
    
    //MARK : Methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        progressBarDisplayer("Loading Mindmap", true)
        //Set values
        presenter =  TableViewPresenter()
        presenter.delegate = self
        //print("Connecting to network....")
        
        presenter.resetConnection()
        
        if(!presenter.connectToServer(mindmapId)) {
            stopProgressBar(Config.NETWORK_ERROR)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableView", name: METEOR_COLLECTION_SET_DID_CHANGE, object: nil)
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter.getNodeCount();
        return count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "NodeViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NodeViewCell
        
        let node = presenter.getNodeAt(indexPath.row);
        
        cell.setData(node , presenter: presenter)
        
        return cell
    }
    

    
    func stopProgressBar(result: String) {
        //print("Conection Result : " , result)
        
        dispatch_async(dispatch_get_main_queue()) {
                self.messageFrame.removeFromSuperview()
        }
        
        switch(result) {
            case Config.CONNECTED:
                //Render Table View 
                //Delete if overhead and not required.
                reloadTableView()
            break
            
            case Config.NETWORK_ERROR  :
                //Render Error View
                print("Error in Network")
                giveAlert(Config.NETWORK_ERROR);
                break
            
            case "Invalid mindmap":
                print("Invalid mindmap")
                giveAlert("Invalid mindmap")
            break
            
            default:
                print("New Error found")
        }
    }
    
    func updateChanges() {
        //print("Final Count : " , presenter.mindmap.count)
        reloadTableView()
    }
    
    func giveAlert(errorMessage : String) {
        let refreshAlert = UIAlertController(title: "Refresh", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            //print("Handle Ok logic here")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            //print("Handle Cancel Logic here")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    private func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        let messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 200, height: 50))
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
        self.messageFrame = messageFrame
        //print("MessageFrame : " , self.messageFrame)
    }
    
}
