//
//  WindowController.swift
//  Timelines
//
//  Created by Mark Huot on 6/19/17.
//  Copyright © 2017 Mark Huot. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.titleVisibility = .hidden
        self.window?.titlebarAppearsTransparent = true
        self.window?.level = Int(CGWindowLevelForKey(.maximumWindow))
        self.window?.styleMask = [.fullSizeContentView/*, .texturedBackground*/];

        let screenFrame = NSScreen.main()!.frame
        self.window?.setFrame(NSMakeRect(0, 0, screenFrame.width, 40), display: true, animate: true)

        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: false)
    }
    
    func tick() {
        let viewController = self.window?.contentViewController as! ViewController
        viewController.collectionView.collectionViewLayout?.invalidateLayout()
    }
    
    
}
