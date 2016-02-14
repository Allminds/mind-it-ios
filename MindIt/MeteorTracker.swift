//
//  MeteorTracker.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import SwiftDDP
import SystemConfiguration

class MeteorTracker : CollectionDelegate {
    //MARK : Properties
    private let mindmap:MindmapCollection
    private static var meteorTracker: MeteorTracker? = nil;
    
    var delagate : TrackerDelegate? //Presenter
    
    var mindmapId:String?
    static var isConnected:Bool = false
    
    //MARK : Intialiser
    private init() {
        mindmap  = MindmapCollection(name: "Mindmaps")
        mindmap.delegate = self
    }
    
    //MARK: Methods
    static func getInstance() -> MeteorTracker {
        if(meteorTracker == nil) {
            meteorTracker = MeteorTracker();
        }
        return meteorTracker!;
    }
    
    
    func getMindmap() -> MindmapCollection {
        return mindmap;
    }
    
    
    func connectToServer(mindmapId: String) -> Bool {
        Meteor.connect(Config.URL) {
            MeteorTracker.isConnected = true
            self.subscribe(mindmapId)
        }
        return true
    }
    
    private func subscribe(mindmapId : String) {
        Meteor.subscribe("mindmap" , params: [mindmapId]) {
            self.mindmapId = mindmapId
            self.mindmapSubscriptionIsReady(Config.CONNECTED)
        }
    }
    
    private func mindmapSubscriptionIsReady(result : String) {
        print("Subscribed to mindmap " , mindmap.count);
        delagate!.connected(result)
    }
    
    func unsubscribe() {
        Meteor.unsubscribe("mindmap")
    }

    
    /*func getChilds(node : Node) -> [Node] {
        var nodes : [Node] = [Node]()
        let childSubTree : [String] = (node.valueForKey("childSubTree") as? [String])!
        
        for childId in childSubTree {
            nodes.append(mindmap.findOne(childId)!)
        }
        return nodes
    }*/
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func determineTypeOfChange(id : String , fields: NSDictionary?) {
        
        let field : String! = fields?.allKeys.first as? String
        
        print("Field Name : " , field)
        
        switch(field) {
            case "name":
                //No reload
                //Change UI mindmap array change only
                break
            case "right":
                // remove from right
                delagate?.changeInRightRemoved((fields?.valueForKey("right") as? [String])!) //Should be Root Ids
                // add in right
                // change order only
                break
            case "left":
                // remove from left
                // add in left
                // change order only
                break
            case "childSubTree":
                // remove from childSubTree
                // add in childSubTree
                // change order only
                break
            case "parentId":
                // Called for add operation
                break
            default:
                break
        }
    }
    
}
