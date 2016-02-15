//
//  Presenter.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

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
            let treeBuilder : TreeBuilder = TreeBuilder();
            mindmap = treeBuilder.buidTreeFromCollection(collection , rootId: meteorTracker.mindmapId!)
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
    
    func notifyDocumentChanged(var collection : MindmapCollection?) {
        if(collection == nil) {
            collection = meteorTracker.getMindmap()
        }
        
        if(isViewInitialised == true) {
            let treeBuilder = TreeBuilder()
            mindmap = treeBuilder.buidTreeFromCollection(collection!, rootId: meteorTracker.mindmapId!)
            delegate.updateChanges()
        }
    }
    
    /*func getChilds(node : Node) {
    var nodes : [Node] = meteorTracker.getChilds(node)
    print(nodes)
    }*/
    
}
