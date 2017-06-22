//
//  MyTaskDelegate.swift
//  Timelines
//
//  Created by Mark Huot on 6/22/17.
//  Copyright © 2017 Mark Huot. All rights reserved.
//

import Foundation

protocol MyTaskDelegate {
    
    func createTask(_ label: String)
    func stopAllRunningTasks()
    
}
