//
//  ViewController.swift
//  LabJukebox
//
//  Created by 直井翔汰 on 2018/04/13.
//  Copyright © 2018年 直井翔汰. All rights reserved.
//

import Cocoa
import MediaPlayer
import FilesProvider

class ViewController: NSViewController {

    @IBOutlet weak var dragAndDropLabel: DragAndDropLabel!
    @IBOutlet weak var backgroundDragAndDropLabel: DragAndDropLabel!
    
    @IBOutlet weak var sendButton: NSButton!
    
    @IBOutlet weak var cancelButton: NSButton!
    
    var musicInfo: MusicInfo!
    var ftpFileProvider: FTPFileProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragAndDropLabel.filePathDelegate = self
        backgroundDragAndDropLabel.filePathDelegate = self
    
        self.ftpFileProvider = FTPServerInfo.setProvider()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.sendButton.isHidden = false
        self.cancelButton.isHidden = false
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func setMusicAfter() {
    
        self.sendButton.isHidden = false
        self.cancelButton.isHidden = false
        
        self.dragAndDropLabel.stringValue = musicInfo.text()
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        //TODO: ProgressBar的なやつを出す別ウィンドウ？
        guard let musicInfo = musicInfo else {
            return
        }
        
        FTPServerInfo().saveItem(path: musicInfo.path)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.dragAndDropLabel.stringValue = "ドラッグ&ドロップ"
        self.sendButton.isHidden = true
        self.cancelButton.isHidden = true
        
        self.musicInfo = nil
    }
    
}


extension ViewController: FilePathDelegate {
    func fileDragged(path: String) {
        print(path)
        let fileName = URL(fileURLWithPath: url).lastPathComponent
        if fileName.contains(".mp3") {
            do {
                musicInfo = MusicInfo.init(path: path)
                print(musicInfo)
                setMusicAfter()
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
