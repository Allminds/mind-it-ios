//
//  MeteorTracker.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import SwiftDDP

class MeteorTracker {
    private let mindmap:MeteorCollection<Node> = MeteorCollection<Node>(name: "Mindmaps")
    private static var meteorTracker: MeteorTracker? = nil;
    
    private init() {
        
    }
    
    static func getInstance() -> MeteorTracker {
        if(meteorTracker == nil) {
            meteorTracker = MeteorTracker();
        }
        return meteorTracker!;
    }
    
    func getMindmap() -> MeteorCollection<Node> {
        return mindmap;
    }
    
    
    func connectToServer(mindmapId: String) -> Bool {
        Meteor.connect(URL) {
            Meteor.subscribe("mindmap" , params: [mindmapId]) {
                self.mindmapSubscriptionIsReady()
            }
        }
        return true;
    }
    
    func mindmapSubscriptionIsReady() {
        print("Subscribed to mindmap");
        //NSNotificationCenter.defaultCenter().postNotificationName("LISTS_SUBSCRIPTION_IS_READY", object: nil);
    }
    
}
