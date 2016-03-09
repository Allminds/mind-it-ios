
class TreeBuilder {
    private var treeNodes : [Node] = [Node]();
    private var presenterDelegate: TreeBuilderDelegate?
    static var subTreeNodes: [String] = [String]()
    
    
    init(presenter : TableViewPresenter) {
        self.presenterDelegate = presenter
    }
    
    func buidTreeFromCollection(mindmapCollection: MindmapCollection ,rootId : String , previousMindmap : [Node]) -> [Node] {
        treeNodes = [Node]()
        setStates(mindmapCollection , previousMindmap : previousMindmap)
        
        let root : Node? = mindmapCollection.findOne(rootId)
        var isCalledFirstTime: Bool = true
        let left : [String]? = root?.getLeft()
        let right : [String]? = root?.getRight()
        
     
        treeNodes.append(root!)
        root?.setDepth(0);
        if(right?.count == 0) {
            presenterDelegate?.lastRightNode = (root?.getId())!
        }
        
        if(root?.getNodeState() == Config.UNDEFINED) {
            root?.setNodeState(Config.EXPANDED)
        }
        else {
            isCalledFirstTime = false
        }
        
        if(right != nil) {
            getRootChilds(right! , mindmapCollection : mindmapCollection  , isCalledFirstTime:  isCalledFirstTime)
            presenterDelegate?.lastRightNode = (treeNodes.last?.getId())!
        }
        
        if(left != nil) {
            getRootChilds(left! , mindmapCollection: mindmapCollection, isCalledFirstTime: isCalledFirstTime)
        }
        
        return treeNodes;
    }
    
    
    private func getRootChilds(nodeIds : [String] , mindmapCollection : MindmapCollection , isCalledFirstTime : Bool ) {
        for rootChildId in nodeIds {
            let rightNode = mindmapCollection.findOne(rootChildId)
            if(rightNode == nil) {
                continue
            }
    
            rightNode?.setDepth(1)
            if(rightNode?.hasChilds() == true) {
                if(rightNode?.getNodeState() == Config.UNDEFINED || rightNode?.getNodeState() == Config.CHILD_NODE) {
                    rightNode?.setNodeState(Config.COLLAPSED)
                }
            }
            else {
                rightNode?.setNodeState(Config.CHILD_NODE)
            }
            
            treeNodes.append(rightNode!)
    
            if(isCalledFirstTime == false && rightNode?.getNodeState() == Config.EXPANDED) {
                traverseTree(rightNode , mindmapCollection: mindmapCollection , depth: 2)
            }
        }
    }
    
    private func traverseTree(root : Node? ,mindmapCollection : MindmapCollection , depth: Int) {
        if(root != nil) {
            
            let childSubTree = root?.getChildSubtree()
            
            for childId in childSubTree! {
                let nextChildNode = mindmapCollection.findOne(childId)
                nextChildNode?.setDepth(depth)
                
                if(nextChildNode != nil) {
                    treeNodes.append(nextChildNode!)
                }
                else {
                    return
                }
                if(nextChildNode?.getNodeState() == Config.UNDEFINED) {
                    if(nextChildNode?.hasChilds() == true) {
                        nextChildNode?.setNodeState(Config.COLLAPSED)
                    }
                    else {
                        nextChildNode?.setNodeState(Config.CHILD_NODE)
                    }
                }
                else if(nextChildNode?.getNodeState() == Config.CHILD_NODE ) {
                    if(nextChildNode?.hasChilds() == true) {
                        nextChildNode?.setNodeState(Config.COLLAPSED)
                    }
                }
                else if(nextChildNode?.getNodeState() == Config.COLLAPSED) {
                    if(nextChildNode?.hasChilds() == false) {
                        nextChildNode?.setNodeState(Config.CHILD_NODE)
                    }
                }
                else if(nextChildNode?.getNodeState() == Config.EXPANDED) {
                    if(nextChildNode?.hasChilds() == false) {
                        nextChildNode?.setNodeState(Config.CHILD_NODE)
                    }
                    else {
                        traverseTree(nextChildNode, mindmapCollection: mindmapCollection, depth: depth + 1)
                    }
                }
            }
        }
    }
    
    
    
    
    func setStates(mindmapCollection : MindmapCollection , previousMindmap : [Node]) {
        for arrayNode in previousMindmap {
            let node : Node? = mindmapCollection.findOne(arrayNode.getId())
            if(node != nil) {
                node!.setNodeState(arrayNode.getNodeState())
            }
        }
    }
    
    static func getChildSubTree(root : Node? ,mindmapCollection : MindmapCollection) {
        if(root != nil) {
            if(root?.getNodeState() == Config.EXPANDED) {
                let childSubTree = root?.getChildSubtree()
                for childId in childSubTree! {
                    let nextChildNode = mindmapCollection.findOne(childId)
                    if(nextChildNode != nil) {
                        subTreeNodes.append((nextChildNode?.getId())!)
                        getChildSubTree(nextChildNode, mindmapCollection: mindmapCollection)
                    }
                }
            }
        }
    }
}
