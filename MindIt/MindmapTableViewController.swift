//
//  MindmapTableViewController.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 08/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import UIKit
import SwiftDDP

class MindmapTableViewController: UITableViewController , TableViewDelegate {
    
    //MARK:Properties
    private var messageFrame = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    private var strLabel = UILabel()
    
    var presenter: TableViewPresenter?
    var mindmapId: String?
    
    
    //MARK : Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableView", name: METEOR_COLLECTION_SET_DID_CHANGE, object: nil)
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter!.getNodeCount();
        return count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NodeViewCell", forIndexPath: indexPath) as! NodeViewCell
        let node = presenter!.getNodeAt(indexPath.row);
        
        cell.textLabel?.text = node.valueForKey("name") as? String;
        cell._id = node.valueForKey("id") as? String;
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        presenter =  TableViewPresenter(tableViewDelegate: self);
        print("Connecting to network....")
        progressBarDisplayer("Loading Mindmap", true)
        if(!presenter!.connectToServer(mindmapId!)) {
            print("Network Error")
        }
        
        //self.tableView.reloadData()
    }
    
    func stopProgressBar(error: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.messageFrame.removeFromSuperview()
        }
        print("Error : " , error)
    }
    
    private func progressBarDisplayer(msg:String, _ indicator:Bool ) {
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
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
