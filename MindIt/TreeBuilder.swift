//
//  TreeBuilder.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 12/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

class TreeBuilder {
    private var treeNodes : [Node] = [Node]();
    static var subTreeNodes : [Node] = [Node]();
    
    
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
        
        
        let left : [String]? = root?.left
        let right : [String]? = root?.right
        
        if(root?.getNodeState() == Config.UNDEFINED) {
            root?.setNodeState(Config.EXPANDED)
        }
        else {
            isCalledFirstTime = false
        }
        
        for rightChildId in right! {
            let rightNode = mindmapCollection.findOne(rightChildId)
            
            if(rightNode != nil) {
                rightNode?.setDepth(1)
                if(rightNode?.hasChilds() == true) {
                    if(rightNode?.getNodeState() == Config.UNDEFINED) {
                        rightNode?.setNodeState(Config.COLLAPSED)
                    }
                }
                else {
                    rightNode?.setNodeState(Config.CHILD_NODE)
                }
                treeNodes.append(rightNode!)
            }
            if(isCalledFirstTime == false && rightNode?.getNodeState() == Config.EXPANDED) {
                traverseTree(rightNode , mindmapCollection: mindmapCollection , depth: 2)
            }
        }
    
        for leftChildId in left! {
            let leftNode = mindmapCollection.findOne(leftChildId)
            if(leftNode != nil) {
                leftNode?.setDepth(1)
                if(leftNode?.hasChilds() == true) {
                    if(leftNode?.getNodeState() == Config.UNDEFINED) {
                        leftNode?.setNodeState(Config.COLLAPSED)
                    }
                }
                else {
                    leftNode?.setNodeState(Config.CHILD_NODE)
                }
                treeNodes.append(leftNode!)
            }
            
            if(isCalledFirstTime == false && leftNode?.getNodeState() == Config.EXPANDED) {
                traverseTree(leftNode , mindmapCollection: mindmapCollection , depth: 2)
            }
        }
        
        return treeNodes;
    }
    
    private func traverseTree(root : Node? ,mindmapCollection : MindmapCollection , depth: Int) {
        if(root != nil) {
            
            let childSubTree = root?.childSubTree
            
            for childId in childSubTree! {
                let nextChildNode = mindmapCollection.findOne(childId)
                nextChildNode?.setDepth(depth)
                
                if(nextChildNode != nil) {
                    treeNodes.append(nextChildNode!)
                }
                
                if(nextChildNode?.getNodeState() == Config.UNDEFINED) {
                    nextChildNode?.setNodeState(Config.CHILD_NODE)
                }
                else if(nextChildNode?.getNodeState() != Config.COLLAPSED) {
                    if(nextChildNode?.hasChilds() == true && nextChildNode?.getNodeState() == Config.CHILD_NODE) {
                        nextChildNode?.setNodeState(Config.EXPANDED)
                    }
                    traverseTree(nextChildNode, mindmapCollection: mindmapCollection , depth: depth + 1)
                } 
            }
        }
    }
    
    static func getChildSubTree(root : Node? ,mindmapCollection : MindmapCollection) {
        if(root != nil) {
            let childSubTree = root?.childSubTree
            
            for childId in childSubTree! {
                let nextChildNode = mindmapCollection.findOne(childId)
                subTreeNodes.append(nextChildNode!)
                if(nextChildNode?.getNodeState() == Config.EXPANDED) {
                    getChildSubTree(nextChildNode, mindmapCollection: mindmapCollection)
                }
            }
        }
    }
}
