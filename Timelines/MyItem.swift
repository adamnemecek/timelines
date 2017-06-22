//
//  MyItem.swift
//  Timelines
//
//  Created by Mark Huot on 6/20/17.
//  Copyright © 2017 Mark Huot. All rights reserved.
//

import Cocoa

class MyItem: NSCollectionViewItem {
    
    var itemView: MyItemView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
//        self.view.wantsLayer = true
//        self.view.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    override func loadView() {
        itemView = MyItemView(frame: NSZeroRect)
        view = itemView!
    }
    
}
