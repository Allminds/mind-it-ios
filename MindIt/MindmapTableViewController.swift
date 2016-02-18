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
    var loader: Loader!
    var activityIndicator : UIActivityIndicatorView!
    var strLabel : UILabel!
    
    var presenter: TableViewPresenter!
    var mindmapId: String!
    
    //MARK : Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter =  TableViewPresenter(viewDelegate: self, meteorTracker: MeteorTracker.getInstance())
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showProgressBar()
        presenter.connectToServer(mindmapId)
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNodeCount();
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "NodeViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NodeViewCell
        
        let node : Node? = presenter.getNodeAt(indexPath.row)
        if(node == nil) {
            cell.nodeDataLabel.text = Config.NETWORK_ERROR
            giveAlert(Config.NETWORK_ERROR)
        }
        else {
            cell.setData(node!, presenter: presenter)
        }
        
        return cell
    }
    
    func didConnectSuccessfully() {
        stopProgressBar()
        dispatch_async(dispatch_get_main_queue(), {
            self.reloadTableView()
        })
    }
    
    func didFailToConnectWithError(error: String) {
        stopProgressBar()
        switch(error) {
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
    
    private func showProgressBar() {
        self.loader = NSBundle.mainBundle().loadNibNamed("Loader", owner: self, options: nil).first as! Loader
        loader.show("Loading Mindmap...")
    }
    
    private func stopProgressBar() {
        dispatch_async(dispatch_get_main_queue()) {
            self.loader.hide()
        }
    }
    
    func updateChanges() {
        dispatch_async(dispatch_get_main_queue(), {
            self.reloadTableView()
            //self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        })
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
    
}
