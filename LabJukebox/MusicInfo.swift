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

struct MusicInfo {
    var title: String = "情報不明"
    var albumName: String = "情報不明"
    var artist: String = "情報不明"
    var artwork : NSImage! = nil
    
    init(url: URL) {
        let items = AVPlayerItem(url: url).asset.commonMetadata
        
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
    }
    
//    init(path: String) {
//        let mp3 = try? MP3File(path: path)
//        print(mp3?.getAlbum())
//        print(mp3?.getArtist())
//        print(mp3?.getTitle())
//        print(mp3?.getLyrics())
//        print(mp3?.getArtwork())
//        let items = AVPlayerItem(url: URL(fileURLWithPath: path)).asset.commonMetadata
//        
//        for item in items {
//            guard let commonKey = item.commonKey?.rawValue,
//                let stringValue = item.stringValue else {
//                    continue
//            }
//            
//            if commonKey == "title" {
//                self.title = stringValue
//            } else if commonKey == "albumName" {
//                self.albumName = stringValue
//            } else if commonKey == "artist" {
//                self.artist = stringValue
//            } else if commonKey == "artwork" {
//                if let data = item.dataValue {
//                    self.artwork = NSImage(data: data)
//                }
//            }
//        }
//    }
}
