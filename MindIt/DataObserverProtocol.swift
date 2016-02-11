//
//  DataObserverProtocol.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 10/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//
import Foundation
protocol DataObserverProtocol {
    func documentAdded(id : String)
    func documentChanged(id : String)
}