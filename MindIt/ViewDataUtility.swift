//
//  ViewDataUtility.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 10/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//
import Foundation
class ViewDataUtility {
    
    //MARK : Properties
   let meteorTracker : MeteorTracker = MeteorTracker.getInstance();
    //MARK :Methods
    func addDocumentToViewData(id : String,mindmap : [Node]){
        var mindmap : [Node] = mindmap;
        print(mindmap)
        let collection : MindmapCollection = meteorTracker.getMindmap()
        let node: Node = collection.findOne(id)!
        print("Node arrived.." , node.getName())
        
        if(self.isNodeValidToInsertInViewData(mindmap, newNodeId: id)) {
           mindmap.append(node)
        }else{
            print("Node is deleted");
        }
    }
    
    func isNodeValidToInsertInViewData(mindmap : [Node] , newNodeId : String) -> Bool{
       
        if(mindmap.count == 0 || isFirstLevelChild(mindmap,newNodeId: newNodeId)){ //Node is root node or first arrived or first level child
            print("is root or first level Child")
            return true;
        }
        var flag = false
        outerLoop : for i in 0...mindmap.count-1 {
            let childSubTree : [String] = mindmap[i].getChildSubtree()
            if(childSubTree.contains(newNodeId)){
                flag = true
                break outerLoop;
            }
        }
        if(flag){
            return true;
        }
        else{
            return false
        }
    }
    func isFirstLevelChild(mindmap : [Node],newNodeId : String) -> Bool{
        let collection : MindmapCollection = meteorTracker.getMindmap()
        let node : Node = collection.findOne(newNodeId)!
        let rootNode : Node = collection.findOne(node.getRootId())!
        let leftChildsOfRoot : [String] = rootNode.getLeft()
        if(leftChildsOfRoot.count != 0 && leftChildsOfRoot.contains(newNodeId)){//check existence in left childs of root.
        return true
        }
        
        let rightChildsOfRoot : [String] = rootNode.getRight()
        if(rightChildsOfRoot.count != 0 && rightChildsOfRoot.contains(newNodeId)){ //check existence in right childs of root.
            return true;
        }
    
        return false;
    }
    
    
    func UpdateDocumentToViewData(id : String){
     
        print("Document get changed ", id)
    
    }
    
}