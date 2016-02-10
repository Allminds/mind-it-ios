//
//  Presenter.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

class Presenter{
    
    //MARK : Properties
    let meteorTracker:MeteorTracker = MeteorTracker.getInstance()
    
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
    
    func getNodes() -> [Node] {
        return meteorTracker.getNodes();
    }
    
}
