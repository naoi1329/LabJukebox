//
//  DragAndDropLabel.swift
//  LabJukebox
//
//  Created by 直井翔汰 on 2018/04/13.
//  Copyright © 2018年 直井翔汰. All rights reserved.
//

import Cocoa
import Foundation // containsに必要だった

enum DragAndDropResult {
    case ok
    case manyFiles
    case error
}

protocol FilePathDelegate {
    func fileDragged(url: URL)
//    func fileDragged(path: String)
}

class DragAndDropLabel: NSTextField {
    
    var filePathDelegate: FilePathDelegate? = nil
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        print("override init(frame frameRect: NSRect)")
        self.registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL, NSPasteboard.PasteboardType.URL])
        
    }
    
    override required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("override required init?(coder: NSCoder)")
        self.registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        self.backgroundColor = NSColor.darkGray
        return .copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray
            else {
                return false
                
        }
        
        guard let path = pasteboard[0] as? String else {
            return false
        }
        //GET YOUR FILE PATH !!!
        print(path)
        
        filePathDelegate?.fileDragged(url: URL(fileURLWithPath: path))
//        filePathDelegate?.fileDragged(path: path)
        return true
    }
}
