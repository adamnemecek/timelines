//
//  CurrentTimeView.swift
//  Timelines
//
//  Created by Mark Huot on 6/21/17.
//  Copyright © 2017 Mark Huot. All rights reserved.
//

import Cocoa

class CurrentTimeView: NSView {
    
    var delegate: MyTaskDelegate?
    
    var timeLabel = NSTextField()
    var timeLabelYConstraint = NSLayoutConstraint()
    
    var newTaskLabel = NSTextField()
    var newTaskYConstraint = NSLayoutConstraint()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        
        self.timeLabel = NSTextField(frame: NSMakeRect(0, 0, 100, 40))
        self.timeLabel.textColor = NSColor(calibratedRed: 255.0, green: 255.0, blue: 255.0, alpha: 0.75)
        self.timeLabel.stringValue = ""
        self.timeLabel.isBezeled = false
        self.timeLabel.isEditable = false
        self.timeLabel.drawsBackground = false
        self.timeLabel.alignment = .center
        self.timeLabel.font = NSFont.labelFont(ofSize: 16)
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.timeLabel)
        
        self.timeLabelYConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.timeLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.timeLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            self.timeLabelYConstraint,
        ])
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)

        self.newTaskLabel = NSTextField(frame: NSMakeRect(0, 0, 100, 40))
        self.newTaskLabel.stringValue = "Foo Bar"
        self.newTaskLabel.font = NSFont.labelFont(ofSize: 14)
        self.newTaskLabel.isBezeled = false
        self.newTaskLabel.isEditable = true
        self.newTaskLabel.drawsBackground = false
        self.newTaskLabel.wantsLayer = true
        self.newTaskLabel.layer?.backgroundColor = NSColor(calibratedRed: 255.0/255.0, green: 235.0/255.0, blue: 59.0/255.0, alpha: 1.0).cgColor
        self.newTaskLabel.layer?.cornerRadius = 5
        self.newTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        self.newTaskLabel.delegate = self
        self.addSubview(self.newTaskLabel)
        
        self.newTaskYConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.newTaskLabel, attribute: .centerY, multiplier: 1.0, constant: -40.0)
        
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.newTaskLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            self.newTaskYConstraint,
        ])
        
        self.newTaskLabel.addConstraints([
            NSLayoutConstraint(item: self.newTaskLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0),
            NSLayoutConstraint(item: self.newTaskLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200.0),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("nope")
    }
    
    func tick() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        self.timeLabel.stringValue = formatter.string(from: date)
    }
    
    public func showNewTask() {
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.25
            self.timeLabelYConstraint.animator().constant = -40.0
            self.newTaskYConstraint.animator().constant = 0.0
        }, completionHandler: nil)
    }
    
    public func hideNewTask() {
        self.newTaskLabel.window?.makeFirstResponder(nil)
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.25
            self.timeLabelYConstraint.animator().constant = 0.0
            self.newTaskYConstraint.animator().constant = -40.0
        }, completionHandler: nil)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let transparent = NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        let black = NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        let gradient = NSGradient(colors: [transparent, black, black, transparent])
        gradient?.draw(in: dirtyRect, angle: 0.0)
    }
    
}

extension CurrentTimeView: NSTextFieldDelegate {
 
    override func keyUp(with event: NSEvent) {
        if (event.keyCode == 36) {
//            self.stopAllTasks();
            self.hideNewTask();
            self.delegate?.stopAllRunningTasks()
            self.delegate?.createTask(self.newTaskLabel.stringValue)
//            self.startNewTask();
        }
    }
    
}
