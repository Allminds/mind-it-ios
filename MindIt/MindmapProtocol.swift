//
//  MindmapProtocol.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 10/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

protocol MindmapProtocol {
    /*optional func collapse();
    optional func expand();
    optional func add();
    optional func delete();*/
    func getNodes() -> [Node]
}
