//
//  MusicInfo.swift
//  LabJukebox
//
//  Created by 直井翔汰 on 2018/04/13.
//  Copyright © 2018年 直井翔汰. All rights reserved.
//

import Foundation
import Cocoa
import MediaPlayer

extension Date {
    static func nowAdd() -> String {
        let format: String = "M/d(E) HH:mm:ss"

        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = format
        
        return formatter.string(from: Date())
    }
}

struct MusicInfo {
    private var title: String? = nil
    private var albumName: String = "情報不明"
    private var artist: String = "情報不明"
    private(set) var artwork: NSImage! = nil
    private var path: String! = nil
    
    init(path: String) {
        self.path = path
        let items = AVPlayerItem(url: URL(fileURLWithPath: path)).asset.commonMetadata
        
        for item in items {
            guard let commonKey = item.commonKey?.rawValue,
                let stringValue = item.stringValue else {
                    continue
            }
            
            if commonKey == "title" {
                self.title = stringValue
            } else if commonKey == "albumName" {
                self.albumName = stringValue
            } else if commonKey == "artist" {
                self.artist = stringValue
            } else if commonKey == "artwork" {
                if let data = item.dataValue {
                    self.artwork = NSImage(data: data)
                }
            }
        }
        
        if title == nil {
            //mp3ファイルに情報がなかった場合、ファイル名を曲名にする
            self.title = path.components(separatedBy: "/").last
        }
    }
    
    func titleText() -> String {
        return "\(self.title!)" //force unwrappingする　ファイル名は絶対入るため
    }
    
    func artistAndAlbumText() -> String {
        return  "\(self.artist) - \(self.albumName)"
    }
}
