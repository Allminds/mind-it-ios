//
//  Presenter.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//
import Foundation

class TableViewPresenter:NSObject, TrackerDelegate {
    
    //MARK : Properties
    var mindmap:[Node] = [Node]()
    private var meteorTracker:MeteorTracker!
    private weak var viewDelegate:PresenterDelegate!
    
    var isViewInitialised = false
    
    //MARK : Initializers
    init(viewDelegate: PresenterDelegate, meteorTracker: MeteorTracker){
        super.init()
        self.viewDelegate = viewDelegate
        self.meteorTracker = meteorTracker
        if(meteorTracker.isConnected) {
            meteorTracker.unsubscribe();
        }
        meteorTracker.delagate = self
    }
    
    
    //MARK : Methods
    func connectToServer(mindmapId: String){
        if(meteorTracker.isConnectedToNetwork()) {
            meteorTracker.connectToServer(mindmapId)
        }
        else {
            viewDelegate.didFailToConnectWithError(Config.NETWORK_ERROR)
        }
    }
    
    func getNodeCount() -> Int{
        return mindmap.count
    }
    
    func getNodeAt(index : Int) -> Node{
        return mindmap[index];
    }
    
    func connected(result: String) {
        let collection = meteorTracker.getMindmap();
        let count : Int = collection.count
        if(count == 0) {
            viewDelegate.didFailToConnectWithError("Invalid mindmap")
        }
        else if(meteorTracker.mindmapId != nil) {
            let treeBuilder : TreeBuilder = TreeBuilder();
            mindmap = treeBuilder.buidTreeFromCollection(collection , rootId: meteorTracker.mindmapId!)
            isViewInitialised = true
            viewDelegate.didConnectSuccessfully()
        }
        else {
            viewDelegate.didFailToConnectWithError(result)
        }
    }
    
    func notifyDocumentChanged(id : String , fields : NSDictionary?) {
        if(isViewInitialised == true) {
            // Call Build tree.
            let collection : MindmapCollection = meteorTracker.getMindmap()
            let node : Node = collection.findOne(id)!
            let rootId : String = node.getRootId()
            
            let treeBuilder : TreeBuilder = TreeBuilder()
            mindmap = treeBuilder.buidTreeFromCollection(collection, rootId: rootId)
            reloadView()
        }
    }
    
    func addSubtree(node : Node) {
        let indexOfNode : Int = mindmap.indexOf(node)! + 1;
        var childSubtree : [String]?
        
        if(node.isRoot()) {
            childSubtree = node.getRootSubTree()
        }
        else {
            childSubtree = node.getChildSubtree()
        }
        for (index , nodeId) in (childSubtree?.enumerate())! {
            let childNode: Node? = meteorTracker.getMindmap().findOne(nodeId)
            if(childNode?.hasChilds() == true) {
                childNode?.setNodeState(Config.COLLAPSED)
            }
            else {
                childNode?.setNodeState(Config.CHILD_NODE)
            }
            childNode?.setDepth(node.getDepth()+1)
            
            mindmap.insert(childNode!, atIndex: indexOfNode + index)
        }
        reloadView();
    }
    func removeSubtree(node : Node) {
        if(node.isRoot() == true) {
            mindmap = [Node]()
            mindmap.append(node)
            reloadView()
            return
        }
        
        let indexOfNode : Int = mindmap.indexOf(node)! + 1;
        let collection = meteorTracker.getMindmap()
        var childSubtreeCount : Int = 0
        
        TreeBuilder.subTreeNodes = [Node]()
        
        TreeBuilder.getChildSubTree(node, mindmapCollection: collection)
        
        childSubtreeCount = TreeBuilder.subTreeNodes.count
        
        print("Child Nodes Count : " , childSubtreeCount)
        
        mindmap.removeRange(Range<Int>(start : indexOfNode, end: indexOfNode + childSubtreeCount))
        reloadView();
    }

    func reloadView(){
        viewDelegate.updateChanges()    //reflect new changes to view
    }
    
}
