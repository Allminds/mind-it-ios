//
//  TrackerDelegate.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 11/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import SwiftDDP

protocol TrackerDelegate {
    func connected(result: String)
    func resetConnection()
    //func notifyDocumentAdded(collection : MindmapCollection , id : String , fields: NSDictionary?) -> Bool
    func changeInRightRemoved(rightArray : [String])
}