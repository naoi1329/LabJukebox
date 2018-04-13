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
import ProgressKit

class ViewController: NSViewController {

    @IBOutlet weak var dragAndDropLabel: DragAndDropLabel!
    @IBOutlet weak var backgroundDragAndDropLabel: DragAndDropLabel!
    
    @IBOutlet weak var sendButton: NSButton!
    
    @IBOutlet weak var cancelButton: NSButton!
    
    var musicInfo: MusicInfo!
    var ftpServer: FTPServerInfo = FTPServerInfo() {
        didSet {
            ftpServer.provider.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragAndDropLabel.filePathDelegate = self
        backgroundDragAndDropLabel.filePathDelegate = self
    
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
        let fileName = URL(fileURLWithPath: path).lastPathComponent
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


extension ViewController: FileProviderDelegate {
    func fileproviderFailed(_ fileProvider: FileProviderOperations, operation: FileOperationType, error: Error) {
        switch operation {
        case .copy(source: let source, destination: let dest):
            print("copy of \(source) failed.")
        case .remove:
            print("file can't be deleted.")
        default:
            print("\(operation.actionDescription) from \(operation.source) to \(operation.destination) failed")
        }
    }
    
    func fileproviderSucceed(_ fileProvider: FileProviderOperations, operation: FileOperationType) {
        switch operation {
        case .copy(source: let source, destination: let dest):
            print("\(source) copied to \(dest).")
        case .remove(path: let path):
            print("\(path) has been deleted.")
        default:
            print("\(operation.actionDescription) from \(operation.source) to \(operation.destination) succeed")
        }
    }
    
    func fileproviderFailed(_ fileProvider: FileProviderOperations, operation: FileOperationType) {
        switch operation {
        case .copy(source: let source, destination: let dest):
            print("copy of \(source) failed.")
        case .remove:
            print("file can't be deleted.")
        default:
            print("\(operation.actionDescription) from \(operation.source) to \(operation.destination) failed")
        }
    }
    
    func fileproviderProgress(_ fileProvider: FileProviderOperations, operation: FileOperationType, progress: Float) {
        switch operation {
        case .copy(source: let source, destination: let dest):
            print("Copy\(source) to \(dest): \(progress * 100) completed.")
        default:
            break
        }
    }
}
