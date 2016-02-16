//
//  Mindmap.swift
//  MindIt-IOS
//
//  Created by Swapnil Gaikwad on 08/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import SwiftDDP

class Node: MeteorDocument {
    
    //MARK : Properties
    var collection:String = "Mindmaps"
    var id : String?
    var parentId:String?
    var position:String?
    var rootId:String?
    var left:[String]?
    var right:[String]?
    var name:String?
    var childSubTree:[String]?
    var index:Int?
    var depth : Int?
    var state: String = Config.UNDEFINED
    
    //MARK : Initialiser
    required init(id: String, fields: NSDictionary?) {
        super.init(id: id, fields: fields)
        self.id = id
    }
    
    //mark : Added new Code
    override func setValue(value: AnyObject?, forKey key: String) {
        switch(key) {
            
        case "parentId":
            parentId = value as? String;
            break
            
        case "position":
            position = value as? String;
            break
            
        case "rootId":
            rootId = value as? String;
            break
            
        case "left":
            left = value as? [String];
            break
            
        case "right":
            right = value as? [String];
            break
            
        case "name":
            name = value as? String;
            break
            
        case "childSubTree":
            childSubTree = value as? [String];
            break
        case "index":
            index = value as? Int;
            break
        default:
            print("No Such element found : " , key);
        }
    }
    func getName() -> String{
        return self.name!
    }
    func getChildSubtree() -> [String]{
        return self.childSubTree!
    }
    func getRootId() -> String {
        if(isRoot()){
            return self.id!
        }
        else{
            return self.rootId!
        }
    }
    func getLeft() -> [String]{
        return self.left!
    }
    func getRight() -> [String]{
        return self.right!
    }
    func getDepth() -> Int{
        return self.depth!
    }
    func getNodeState() -> String {
        return state
    }
    
    func getId() -> String {
        return id!
    }
    
    func getRootSubTree() -> [String] {
        return right! + left!
    }
    
    func isRoot() ->Bool{
        if(self.parentId == nil){
            return true;
        }
        else{
            return false;
        }
    }
    
    func setDepth(depth : Int) {
        self.depth = depth
    }
    func setNodeState(state : String) {
        self.state = state
    }
    
    
    func hasChilds() -> Bool {
        //Root Element
        if(parentId == nil) {
            if(left?.count > 0 || right?.count > 0) {
                return true
            }
            else {
                return false
            }
        }
        //For non - Root element.
        else if(childSubTree?.count == 0) {
            return false
        }
        else {
            return true
        }
    }
}
