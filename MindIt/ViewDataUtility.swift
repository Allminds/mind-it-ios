//
//  ViewDataUtility.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 10/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

class ViewDataUtility {
    //MARK : Properties
    let presenter : Presenter = Presenter.getInstance();
    
    //MARK :Methods
    func addDocumentToViewData(id : String){
        var mindmap : [Node] = presenter.mindmap!;
        print(mindmap)
        let collection : MindmapCollection = presenter.meteorTracker.getMindmap()
        let node: Node = collection.findOne(id)!;
        mindmap.append(node)
        print("Added node to mindmap : " , node)
    }
    
}