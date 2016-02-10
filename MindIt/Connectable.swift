//
//  connectable.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 10/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

protocol Connectable {
    func connectToServer(url: String) -> Bool;
}
