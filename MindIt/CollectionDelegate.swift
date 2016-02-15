//
//  CollectionDelegate.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 14/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//
import Foundation

protocol CollectionDelegate {
    func notifyDocumentChanged(id : String , fields : NSDictionary?)
}
