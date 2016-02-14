//
//  Presenter.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//
import SwiftDDP

class TableViewPresenter:TrackerDelegate {
    
    //MARK : Properties
    var mindmap:[Node] = [Node]()
    var meteorTracker:MeteorTracker!
    var delegate:PresenterDelegate!
    
    var isViewInitialised = false
    
    //MARK : Initializers
    init(){
        meteorTracker = MeteorTracker.getInstance();
        meteorTracker.delagate = self
    }
    
    
    //MARK : Methods
    func connectToServer(mindmapId: String) -> Bool {
        if(meteorTracker.isConnectedToNetwork()) {
            meteorTracker.connectToServer(mindmapId)
            return true
        }
        else {
            return false
        }
    }

    func getNodeCount() -> Int{
        return mindmap.count
    }
    
    func getNodeAt(index : Int) -> Node{
        return mindmap[index];
    }
    
    func connected(var result: String) {
        let collection = meteorTracker.getMindmap();
        let count : Int = collection.count
        if(count == 0) {
            result = "Invalid mindmap";
        }
        else if(meteorTracker.mindmapId != nil) {
            //mindmap = collection.sorted
            let treeBuilder : TreeBuilder = TreeBuilder();
            mindmap = treeBuilder.buidTreeFromCollection(collection , rootId: meteorTracker.mindmapId!)
            //print("Tree Node Count to Display : " , mindmap.count)
            isViewInitialised = true
        }
        else {
            print("Error in Presenter No MindmapID")
        }
        delegate.stopProgressBar(result)
    }
    
    func resetConnection() {
        if(MeteorTracker.isConnected) {
            meteorTracker.unsubscribe();
        }
    }
    
    func changeInRightRemoved(rightArray : [String]) {
        let collection = meteorTracker.getMindmap();
        let treeBuilder : TreeBuilder = TreeBuilder();
        mindmap = treeBuilder.buidTreeFromCollection(collection , rootId: meteorTracker.mindmapId!)
        delegate.updateUI()
    }
    
    /*func notifyDocumentAdded(collection : MindmapCollection ,id : String , fields: NSDictionary?) -> Bool {
        //print("Updated Mindmap Count : " , mindmap.count)
        if(isViewInitialised == true) {
            /*let treeBuilder = TreeBuilder()
            mindmap = treeBuilder.buidTreeFromCollection(collection, rootId: meteorTracker.mindmapId!)*/
            
            let newNode : Node? = collection.findOne(id)
            
            if(newNode != nil) {
                let rootNode = mindmap[0]
                //var countFromRoot = 0;

                for (index , rightChildId) in rootNode.right!.enumerate() {
                    if(rightChildId == id && rootNode.isExpanded) {
                        mindmap.insert(newNode!, atIndex: index + 1)
                        delegate.updateChanges()
                        return true
                    }
                }
                
                for (index , leftChildId) in rootNode.left!.enumerate() {
                    if(leftChildId == id && rootNode.isExpanded) {
                        mindmap.insert(newNode!, atIndex: (rootNode.right?.count)! + index + 1)
                        delegate.updateChanges()
                        return true
                    }
                }
                

                
                for node in mindmap {
                    let childSubTree = node.childSubTree
                    for (index , childId) in childSubTree!.enumerate() {
                        if(childId == id && node.isExpanded) {
                            mindmap.insert(newNode!, atIndex: index)
                            print("Tree Node Count to Display : " , mindmap.count)
                            delegate.updateChanges()
                            return true
                        }
                    }
                }
            }
        }
        return false
    }*/
    
    /*func getChilds(node : Node) {
        var nodes : [Node] = meteorTracker.getChilds(node)
        print(nodes)
    }*/
    
}
