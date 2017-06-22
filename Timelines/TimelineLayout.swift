//
//  TimelineLayout.swift
//  Timelines
//
//  Created by Mark Huot on 6/20/17.
//  Copyright © 2017 Mark Huot. All rights reserved.
//
// inspiration from https://gist.github.com/rdougan/e54214c5f27f5807b16b

import Cocoa

class TimelineLayout: NSCollectionViewLayout {

    var scale = 1.0
    var speed = 1.0
    
    override func prepare() {
        // do some prep
    }
    
    override var collectionViewContentSize: NSSize {
        get {
//            let intCount = self.collectionView?.numberOfItems(inSection: 0)
//            let count = CGFloat(intCount!)
//            let size = NSSize(width: (count * 40.0) + (count * 10.0), height: 40.0)
//            return size
            
            return (self.collectionView?.frame.size)!
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        let appDelegate = NSApplication.shared().delegate as? AppDelegate
        let moc = appDelegate?.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let result = try! moc?.fetch(request)
        let task = result![indexPath.item] as! Task
        let start = task.startedAt
        let end = task.endedAt != nil ? task.endedAt : NSDate()
        let x = CGFloat((start?.timeIntervalSinceNow)!) + ((self.collectionView?.frame.width)! / 2)
        let interval = end?.timeIntervalSince(start! as Date)
        let width = interval! * scale
        
        let attributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
        attributes.frame = NSMakeRect(x, 5, CGFloat(width), 30.0)
        
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        let count = self.collectionView?.numberOfItems(inSection: 0) as Int!
        var attributes = [NSCollectionViewLayoutAttributes]()
        
        if (count == 0) {
            return attributes
        }
        
        for index in 0...(count! - 1) {
            let indexPath = IndexPath(item: index, section: 0)
            if let itemAttributes = self.layoutAttributesForItem(at: indexPath) {
                attributes.append(itemAttributes)
            }
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        return true
    }
    
}
