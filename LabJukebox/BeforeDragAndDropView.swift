//
//  BeforeDragAndDropView.swift
//  LabJukebox
//
//  Created by 直井翔汰 on 2018/04/15.
//  Copyright © 2018年 直井翔汰. All rights reserved.
//

import Foundation
import Cocoa

class BeforeDragAndDropView: NSView {
    
    var filePathDelegate: FilePathDelegate? = nil
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        print("\(type(of: self))override init(frame frameRect: NSRect)")
        self.registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL, NSPasteboard.PasteboardType.URL])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("\(type(of: self))override required init?(coder: NSCoder)")
        self.registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
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
        
        print(path)
        filePathDelegate?.fileDragged(path: path)
        //        filePathDelegate?.fileDragged(path: path)
        return true
    }
}
