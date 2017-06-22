//
//  MyItemView.swift
//  Timelines
//
//  Created by Mark Huot on 6/20/17.
//  Copyright © 2017 Mark Huot. All rights reserved.
//

import Cocoa

class MyItemView: NSView {
    
    var label: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
//        print("huh...")
        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        self.wantsLayer = true
        self.layer?.cornerRadius = 5
        self.layer?.backgroundColor = NSColor(calibratedRed: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        
        label = NSTextField(frame: NSMakeRect(5, 5, 30, 20))
        label.isEditable = false
        label.stringValue = "Label"
        label.isBezeled = false
        label.isEditable = false
        label.drawsBackground = false
        label.textColor = NSColor.white
        label.font = NSFont.labelFont(ofSize: 14)
//        label.wantsLayer = true
//        label.layer?.backgroundColor = NSColor.clear.cgColor
        addSubview(label)
    }
    
}
