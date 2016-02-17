//
//  TreeBuilder.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 12/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

class TreeBuilder {
    private var treeNodes : [Node] = [Node]();
    private var presenterDelegate: TreeBuilderDelegate?
    static var subTreeNodes: [String] = [String]()
    
    
    init(presenter : TableViewPresenter) {
        self.presenterDelegate = presenter
    }
    
    func buidTreeFromCollection(mindmapCollection: MindmapCollection ,rootId : String) -> [Node] {
        let root : Node? = mindmapCollection.findOne(rootId)
        
        var isCalledFirstTime: Bool = true
        
        if(root != nil) {
            treeNodes.append(root!)
            root?.setDepth(0);
        }
        else {
            return [Node]()
        }
        
        
        let left : [String]? = root?.getLeft()
        let right : [String]? = root?.getRight()
        
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
            for rightChildId in right! {
                let rightNode = mindmapCollection.findOne(rightChildId)
                if(rightNode == nil) {
                    continue
                }
                
                rightNode?.setDepth(1)
                if(rightNode?.hasChilds() == true) {
                    if(rightNode?.getNodeState() == Config.UNDEFINED) {
                        rightNode?.setNodeState(Config.COLLAPSED)
                    }
                    else if(rightNode?.getNodeState() == Config.CHILD_NODE) {
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
            presenterDelegate?.lastRightNode = (treeNodes.last?.getId())!
        }
        
        
        if(left != nil) {
            for leftChildId in left! {
                let leftNode = mindmapCollection.findOne(leftChildId)
                
                if(leftNode == nil) {
                    continue
                }
                
                leftNode?.setDepth(1)
                if(leftNode?.hasChilds() == true) {
                    if(leftNode?.getNodeState() == Config.UNDEFINED) {
                        leftNode?.setNodeState(Config.COLLAPSED)
                    }
                    else if(leftNode?.getNodeState() == Config.CHILD_NODE) {
                        leftNode?.setNodeState(Config.COLLAPSED)
                    }
                }
                else {
                    leftNode?.setNodeState(Config.CHILD_NODE)
                }
                treeNodes.append(leftNode!)
                
                if(isCalledFirstTime == false && leftNode?.getNodeState() == Config.EXPANDED) {
                    traverseTree(leftNode , mindmapCollection: mindmapCollection , depth: 2)
                }
            }
        }
        
        return treeNodes;
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
                    //Code refactor
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
