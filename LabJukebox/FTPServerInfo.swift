//
//  FTPServerInfo.swift
//  LabJukebox
//
//  Created by 直井翔汰 on 2018/04/13.
//  Copyright © 2018年 直井翔汰. All rights reserved.
//

import Foundation
import FilesProvider

struct FTPServerInfo {
    
    var provider: FTPFileProvider!
    
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
    
    init() {
        setProvider()
    }
    
    private func setProvider() -> FTPFileProvider? {
        let credential = URLCredential(user: username, password: password, persistence: .permanent)
        guard let provider = FTPFileProvider(baseURL: URL(fileURLWithPath: server), credential: credential) else {
            return nil
        }
        
        return provider
    }
    
    func saveItem(path: String) {
        provider.copyItem(localFile: URL(fileURLWithPath: path), to: storagePath, overwrite: true, completionHandler: nil)
    }
}
