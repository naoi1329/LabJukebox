//
//  FTPServerInfo.swift
//  LabJukebox
//
//  Created by 直井翔汰 on 2018/04/13.
//  Copyright © 2018年 直井翔汰. All rights reserved.
//

import Foundation
import FilesProvider

enum FTPResult {
    case success
    case failed
}

struct FTPServerInfo {
    
    var provider: FTPFileProvider! = nil
    
    private var server: String {
        return ""
    }
    
    private var username: String {
        return ""
    }
    
    private var password: String {
        return ""
    }
    
    private var storagePath: String {
        return ""
    }
    
    mutating func saveItem(path: String) {
        provider = setProvider()
        
        if provider == nil {
            return
        }
        provider.delegate = self
        
        provider.copyItem(localFile: URL(fileURLWithPath: path), to: storagePath, overwrite: true, completionHandler: nil)
    }
    
    private func setProvider() -> FTPFileProvider? {
        let credential = URLCredential(user: username, password: password, persistence: .permanent)
        guard let provider = FTPFileProvider(baseURL: URL(fileURLWithPath: server), credential: credential) else {
            return nil
        }
        
        return provider
    }
}

extension FTPServerInfo: FileProviderDelegate {
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
