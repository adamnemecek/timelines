//
//  ViewController.swift
//  Timelines
//
//  Created by Mark Huot on 6/19/17.
//  Copyright © 2017 Mark Huot. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var label = CurrentTimeView()
    var button = NSButton()
    public var collectionView = NSCollectionView()
    
    var item = NSTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.layer?.backgroundColor = NSColor.black.cgColor
        
        addTimelineView()
        addTimeView()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        addTracking()
    }
    
    private func addTracking() {
        let area = NSTrackingArea(rect: self.view.frame, options: [.activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil)
        self.view.addTrackingArea(area)
    }
    
    override func mouseEntered(with event: NSEvent) {
        self.label.showNewTask()
    }
    
    override func mouseExited(with event: NSEvent) {
        self.label.hideNewTask()
    }
    
    private func addTimelineView() {
        self.collectionView = NSCollectionView(frame: NSZeroRect)
        self.collectionView.collectionViewLayout = TimelineLayout()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColors = [NSColor.clear]
        self.collectionView.register(MyItem.self, forItemWithIdentifier: "MyItem")
        
        let scrollView = NSScrollView(frame: self.view.frame)
        scrollView.drawsBackground = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView = self.collectionView
        self.view.addSubview(scrollView)
        
        self.view.addConstraints([
            NSLayoutConstraint(item: self.view, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.view, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.view, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1.0, constant: 0.0)
        ])
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    func tick() {
        self.collectionView.collectionViewLayout?.invalidateLayout()
    }
    
    private func addTimeView() {
        self.label = CurrentTimeView(frame: NSMakeRect(0, 0, 100, 40))
        self.label.delegate = self
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        
        self.view.addConstraints([
            NSLayoutConstraint(item: self.view, attribute: .centerX, relatedBy: .equal, toItem: label, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.view, attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY, multiplier: 1.0, constant: 0.0),
        ])
        
        label.addConstraints([
            NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200.0),
            NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0),
        ])
    }


}

extension ViewController: NSCollectionViewDelegate {
    
}

extension ViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        let appDelegate = NSApplication.shared().delegate as? AppDelegate
        let moc = appDelegate?.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let results = try! moc?.fetch(request)
        
        return results!.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: "MyItem", for: indexPath) as! MyItem
        
        let appDelegate = NSApplication.shared().delegate as? AppDelegate
        let moc = appDelegate?.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let result = try! moc?.fetch(request)
        let task = result![indexPath.item] as! Task
        item.itemView?.label.stringValue = task.title!
        if (task.endedAt != nil) {
            item.itemView?.wantsLayer = true
            item.itemView?.layer?.backgroundColor = NSColor(calibratedRed: 255.0, green: 255.0, blue: 255.0, alpha: 0.2).cgColor
        }
        
        return item
    }
    
}

extension ViewController: NSCollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 40, height: 40)
    }
    
}

extension ViewController: MyTaskDelegate {
    
    
    func createTask(_ label: String) {
        let appDelegate = NSApplication.shared().delegate as? AppDelegate
        let moc = appDelegate?.persistentContainer.newBackgroundContext()
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: moc!) as! Task
        task.title = label
        task.startedAt = NSDate()
        try! moc?.save()
        self.collectionView.reloadData()
    }
    
    func stopAllRunningTasks() {
        let appDelegate = NSApplication.shared().delegate as? AppDelegate
        let moc = appDelegate?.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let results = try! moc?.fetch(request)
        for task in results! as! [Task] {
            task.endedAt = NSDate()
        }
        try! moc?.save()
        self.collectionView.reloadData()
    }
}
