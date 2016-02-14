//
//  TrackerDelegate.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 11/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//


protocol TrackerDelegate {
    func connected(result: String)
    func resetConnection()
    func notifyDocumentAdded(collection : MindmapCollection)
}