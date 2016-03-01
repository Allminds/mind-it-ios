
import SwiftDDP
import SystemConfiguration

class MeteorTracker : CollectionDelegate {
    
    //MARK : Properties
    private let mindmap: MindmapCollection
    private static var meteorTracker: MeteorTracker? = nil;
    
    weak var delegate : TrackerDelegate?
    var mindmapId:String?
    
    //MARK : Intialiser
    private init() {
        mindmap  = MindmapCollection()
        mindmap.delegate = self
    }
    
    //MARK: Methods
    static func getInstance() -> MeteorTracker {
        if(meteorTracker == nil) {
            meteorTracker = MeteorTracker()
        }
        return meteorTracker!
    }
    
    func getMindmap() -> MindmapCollection {
        return mindmap;
    }
    
    func connectToServer(mindmapId: String) -> Bool {
        if(mindmapId == Config.FIRST_CONNECT && self.mindmapId == nil) {
            return false
        }
        else if(mindmapId == Config.FIRST_CONNECT && self.mindmapId != nil) {
            self.subscribe(self.mindmapId!)
        }
        else {
            self.subscribe(mindmapId)
        }
        return true
    }
    
    private func subscribe(mindmapId : String) {
            let result : String = Meteor.subscribe("mindmap" , params: [mindmapId]) {
                self.mindmapId = mindmapId
                self.mindmapSubscriptionIsReady(Config.CONNECTED)
            }
            print("Result : " , result)
            if(result.containsString("already subscribed")) {
                Meteor.unsubscribe("mindmap") {
                    Meteor.subscribe("mindmap" , params: [mindmapId]) {
                        self.mindmapSubscriptionIsReady(Config.CONNECTED)
                    }
                }
            }
    }
    
    private func mindmapSubscriptionIsReady(result : String) {
        print("Subscribed to mindmap " , mindmap.count);
        delegate?.connected(result)
    }
    
    func unsubscribe() {
        Meteor.unsubscribe("mindmap")
    }
    
    func notifyDocumentChanged(id: String , fields : NSDictionary?) {
        delegate?.notifyDocumentChanged(id , fields: fields)
    }
    
    func isConnectedToNetwork() -> Bool {   //methos checks connectivity to network
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
