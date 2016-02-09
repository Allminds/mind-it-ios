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
    var parentId:String?
    var position:String?
    var rootId:String?
    var left:[String]?
    var right:[String]?
    var name:String?
    var childSubTree:[String]?
    var index:Int?
    
    //MARK : Initialiser
    required init(id: String, fields: NSDictionary?) {
        super.init(id: id, fields: fields)
        
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
}
