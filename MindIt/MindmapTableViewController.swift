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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        progressBarDisplayer()
        
        presenter =  TableViewPresenter()
        presenter.delegate = self
        
        presenter.resetConnection()
        
        if(!presenter.connectToServer(mindmapId)) {
            stopProgressBar(Config.NETWORK_ERROR)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
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
        
        let node = presenter.getNodeAt(indexPath.row);
        cell.setData(node, presenter: presenter)
        return cell
    }
    
    
    
    func stopProgressBar(result: String) {
        //print("Conection Result : " , result)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.loader.hide()
        }
        
        switch(result) {
        case Config.CONNECTED:
            //Render Table View
            dispatch_async(dispatch_get_main_queue(), {
                self.reloadTableView()
            })
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
        dispatch_async(dispatch_get_main_queue(), {
            self.reloadTableView()
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
    
    private func progressBarDisplayer() {
        self.loader = NSBundle.mainBundle().loadNibNamed("Loader", owner: self, options: nil).first as! Loader
        loader.show("Loading Mindmap...")
    }
    
}
