//
//  Presenter.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

class TableViewPresenter:TrackerDelagate {
    
    //MARK : Properties
    var mindmap:[Node] = [Node]();
    var meteorTracker:MeteorTracker?
    let presenterDelegate:PresenterDelegate
    
    //MARK : Initializers
    init(presenterDelegate : PresenterDelegate){
        self.presenterDelegate = presenterDelegate;
        meteorTracker = MeteorTracker.getInstance(self);
    }
    
    
    //MARK : Methods
    func connectToServer(mindmapId: String) -> Bool {
        if(meteorTracker!.isConnectedToNetwork()) {
            meteorTracker!.connectToServer(mindmapId)
            return true
        }
        else {
            return false
        }
    }
    
    func getNodes() -> [Node] {
        mindmap = meteorTracker!.getNodes();
        return mindmap;
    }
    
    func getNodeCount() -> Int{
        mindmap = meteorTracker!.getMindmap().sorted
        return mindmap.count
    }
    
    func getNodeAt(index : Int) -> Node{
        return mindmap[index];
    }
    
    func connected(error: String) {
        presenterDelegate.stopProgressBar(error)
    }
}
