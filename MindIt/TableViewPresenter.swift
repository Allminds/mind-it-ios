
import Foundation

class TableViewPresenter:NSObject, TrackerDelegate , TreeBuilderDelegate {
    
    //MARK : Properties
    var mindmap:[Node] = [Node]()
    private var meteorTracker:MeteorTracker!
    var isViewInitialised = false
    var lastRightNode = "";
    private weak var viewDelegate:PresenterDelegate!
    
    //MARK : Initializers
    init(viewDelegate: PresenterDelegate, meteorTracker: MeteorTracker) {
        super.init()
        self.viewDelegate = viewDelegate
        self.meteorTracker = meteorTracker
        meteorTracker.delegate = self
    }
    
    //MARK : Methods
    func connectToServer(mindmapId: String) {
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(Config.MAXIMUM_LOADING_TIME), target: self, selector: Selector("invalidateConnection"), userInfo: nil, repeats: false)
        
        if(meteorTracker.isConnectedToNetwork()) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
            })
            meteorTracker.connectToServer(mindmapId)
        }
        else {
            viewDelegate.didFailToConnectWithError(Config.NETWORK_ERROR)
        }
    }
    
    func invalidateConnection() {
        if(!(MeteorTracker.getInstance().subscriptionSuccess)){
            if(self.viewDelegate != nil){
                self.viewDelegate.didFailToConnectWithError(Config.UNKNOWN_ERROR)

            }
        }
    }
    
    func getNodeCount() -> Int {
        return mindmap.count
    }
    
    func getNodeAt(index : Int) -> Node? {
        if(index < mindmap.count) {
            return mindmap[index]
        }
        else {
            return nil
        }
    }
    
    func connected(result: String) {
        let collection = meteorTracker.getMindmap();
        let count : Int = collection.count
        if(count == 0) {
            viewDelegate.didFailToConnectWithError(Config.INVALID_MINDMAP)
        }
        else if(meteorTracker.mindmapId != nil) {
            let treeBuilder : TreeBuilder = TreeBuilder(presenter: self);
            
            mindmap = treeBuilder.buidTreeFromCollection(collection , rootId: meteorTracker.mindmapId! , previousMindmap: mindmap)
            isViewInitialised = true
            viewDelegate.didConnectSuccessfully()
        }
        else {
            viewDelegate.didFailToConnectWithError(result)
        }
    }
    
    func notifyDocumentChanged(id : String , fields : NSDictionary?) {
          if(isViewInitialised == true) {
            let collection : MindmapCollection = meteorTracker.getMindmap()
            let node : Node = collection.findOne(id)!
            let rootId : String = node.getRootId()
            let treeBuilder : TreeBuilder = TreeBuilder(presenter: self)
            mindmap = treeBuilder.buidTreeFromCollection(collection, rootId: rootId , previousMindmap: mindmap)
            reloadTableView()
            
        }
    }
    
    //Expand
    func addSubtree(node : Node) {
        let indexOfNode : Int? = mindmap.indexOf(node);
        var childSubtree : [String]?
        
        if(node.isRoot()) {
            childSubtree = node.getRootSubTree()
        }
        else {
            childSubtree = node.getChildSubtree()
        }
        var childNode : Node?
        for (index , nodeId) in (childSubtree?.enumerate())! {
            childNode = meteorTracker.getMindmap().findOne(nodeId)
            if(childNode?.hasChilds() == true) {
                childNode?.setNodeState(Config.COLLAPSED)
            }
            else {
                childNode?.setNodeState(Config.CHILD_NODE)
            }
            childNode?.setDepth(node.getDepth()+1)
            
            if(childNode != nil && indexOfNode != nil) {
                mindmap.insert(childNode!, atIndex: indexOfNode! + index + 1)
            }
            
        }
        if(self.lastRightNode == node.getId()){
            self.lastRightNode = (childNode?.getId())!
        }
        reloadTableView();
    }
    
    //Collapse
    func removeSubtree(node : Node) {
        let indexOfNode : Int = mindmap.indexOf(node)! + 1;
        let collection = meteorTracker.getMindmap()
        TreeBuilder.subTreeNodes = [String]()
        //Set SubTreeNodes
        TreeBuilder.getChildSubTree(node, mindmapCollection: collection)
        //Display SubTreeNodes
        mindmap.removeRange(Range<Int>(start : indexOfNode, end: indexOfNode + TreeBuilder.subTreeNodes.count))
        
        if(TreeBuilder.subTreeNodes.contains(self.lastRightNode)){
            self.lastRightNode = node.getId();
        }
        reloadTableView();
    }

    func reloadTableView(){
        viewDelegate.updateChanges()
    }
    
    func unsubscribe() {
        meteorTracker.unsubscribe()
    }
}
