//
//  ViewController.swift
//  LabJukebox
//
//  Created by 直井翔汰 on 2018/04/13.
//  Copyright © 2018年 直井翔汰. All rights reserved.
//

import Cocoa
import MediaPlayer

class ViewController: NSViewController {

    @IBOutlet weak var dragAndDropLabel: DragAndDropLabel!
    @IBOutlet weak var backgroundDragAndDropLabel: DragAndDropLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragAndDropLabel.filePathDelegate = self
        backgroundDragAndDropLabel.filePathDelegate = self
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func setMusicAfter() {
        self.dragAndDropLabel.isHidden = true
        self.backgroundDragAndDropLabel.isHidden = true
    }
}


extension ViewController: FilePathDelegate {
    func fileDragged(url: URL) {
        print(url)
        let fileName = url.lastPathComponent
        if fileName.contains(".mp3") {
            do {
                let musicInfo = MusicInfo.init(url: url)
                print(musicInfo)
            } catch {
                // error ファイル読み込みに失敗しました.
                let alert = NSAlert.init()
                alert.messageText = "ファイル読み込みに失敗しました。"
                alert.addButton(withTitle: "OK")
                alert.alertStyle = .warning
                alert.runModal()
            }
        } else {
            // error MP3じゃありません
            let alert = NSAlert.init()
            alert.messageText = "mp3ファイルでありません。"
            alert.alertStyle = .warning
            alert.runModal()
        }
    }
    
//    func fileDragged(path: String) {
//        let fileName = URL(fileURLWithPath: path).lastPathComponent
//        if path.contains(".mp3") {
//            do {
//                let musicInfo = MusicInfo.init(path: path)
//                print(musicInfo)
//            } catch {
//                // error ファイル読み込みに失敗しました.
//                let alert = NSAlert.init()
//                alert.messageText = "ファイル読み込みに失敗しました。"
//                alert.addButton(withTitle: "OK")
//                alert.alertStyle = .warning
//                alert.runModal()
//            }
//        } else {
//            // error MP3じゃありません
//            let alert = NSAlert.init()
//            alert.messageText = "mp3ファイルでありません。"
//            alert.alertStyle = .warning
//            alert.runModal()
//        }
//    }
}
