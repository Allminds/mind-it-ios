//
//  TreeBuilder.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 12/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

class TreeBuilder {
    func buidTreeFromCollection(mindmapCollection: MindmapCollection ,rootId : String) -> [Node] {
        var treeNodes : [Node] = [Node]();
        
        let root : Node = mindmapCollection.findOne(rootId)!
        treeNodes.append(root)
        
        return treeNodes;
    }
}
