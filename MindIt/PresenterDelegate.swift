//
//  PresenterDelegate.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 11/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import Foundation

protocol PresenterDelegate: NSObjectProtocol {
    func didConnectSuccessfully()
    func didFailToConnectWithError(error: String)
    func updateChanges()
}
