//
//  TrackerDelegate.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 11/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import Foundation

protocol TrackerDelegate: NSObjectProtocol {
    func connected(result: String)
    func notifyDocumentChanged(id : String , fields : NSDictionary?)
}