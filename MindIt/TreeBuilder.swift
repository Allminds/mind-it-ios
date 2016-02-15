//
//  TreeBuilder.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 12/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

class TreeBuilder {
    private var treeNodes : [Node] = [Node]();
    
    
    func buidTreeFromCollection(mindmapCollection: MindmapCollection ,rootId : String) -> [Node] {
        let root : Node? = mindmapCollection.findOne(rootId)
        
        if(root != nil) {
            treeNodes.append(root!)
        }
        
        let left : [String]? = root?.left
        let right : [String]? = root?.right
        
        if(right != nil) {
            for rightChildId in right! {
                let rightNode = mindmapCollection.findOne(rightChildId)
                traverseTree(rightNode , mindmapCollection: mindmapCollection)
            }
        }
        
        if(left != nil) {
            for leftChildId in left! {
                let leftNode = mindmapCollection.findOne(leftChildId)
                traverseTree(leftNode , mindmapCollection: mindmapCollection)
            }
        }
        
        return treeNodes;
    }
    
    private func traverseTree(root : Node? ,mindmapCollection : MindmapCollection) {
        if(root != nil) {
            treeNodes.append(root!)
            let childSubTree = root?.childSubTree
            
            for childId in childSubTree! {
                let nextChildNode = mindmapCollection.findOne(childId)
                traverseTree(nextChildNode, mindmapCollection: mindmapCollection)
            }
        }
    }
}
