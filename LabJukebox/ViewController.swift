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
    
    @IBOutlet weak var afterDragAndDropView: AfterDragAndDropView!
    @IBOutlet weak var beforeDragAndDropView: BeforeDragAndDropView!
    
    var musicInfo: MusicInfo!
    var ftpServer: FTPServerInfo = FTPServerInfo() {
        didSet {
            ftpServer.provider.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.afterDragAndDropView.isHidden = true
        afterDragAndDropView.delegate = self
        afterDragAndDropView.filePathDelegate = self
        
        beforeDragAndDropView.filePathDelegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func setMusicAfter() {
        //TODO: AfterDragAndDropViewを表示して,musicInfoの値を登録
    }
    
}


extension ViewController: FilePathDelegate {
    
    func fileDragged(path: String) {
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
}

extension ViewController: AfterDrogAndDropViewDelegate {
    func cancel() {
        //TODO: キャンセル処理 BeforeDragAndDropViewを表示して,musicInfoをnilへ
        
    }
    
    func send() {
        //TODO: ファイル送信部分 musicInfoをもとにftpで送信する処理を書く
        //      progress画面も出す
    }
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
