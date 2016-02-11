//
//  MeteorTracker.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import SwiftDDP
import SystemConfiguration

class MeteorTracker {
    //MARK : Properties
    private let mindmap:MindmapCollection = MindmapCollection(name: "Mindmaps")
    private static var meteorTracker: MeteorTracker? = nil;
    let tableViewPresenterDelegate : TableViewPresenterDelegate
    
    //MARK : Intialiser
    private init(tableViewPresenterDelegate : TableViewPresenterDelegate) {
        self.tableViewPresenterDelegate = tableViewPresenterDelegate;
    }
    
    //MARK: Methods
    static func getInstance(tableViewPresenterDelegate : TableViewPresenterDelegate) -> MeteorTracker {
        if(meteorTracker == nil) {
            meteorTracker = MeteorTracker(tableViewPresenterDelegate: tableViewPresenterDelegate);
        }
        return meteorTracker!;
    }
    
    func getMindmap() -> MindmapCollection {
        return mindmap;
    }
    
    
    func connectToServer(mindmapId: String) -> Bool {
        Meteor.connect(Config.URL) {
            Meteor.subscribe("mindmap" , params: [mindmapId]) {
                self.mindmapSubscriptionIsReady()
            }
        }
        return true;
    }
    
    func mindmapSubscriptionIsReady() {
        print("Subscribed to mindmap " , mindmap.count);
        tableViewPresenterDelegate.stopProgressBar("Working")
        //NSNotificationCenter.defaultCenter().postNotificationName("LISTS_SUBSCRIPTION_IS_READY", object: nil);
    }
    
    func getNodes() -> [Node] {
        return mindmap.sorted;
    }
    
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
    
}
