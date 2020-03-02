//
//  ProfileVM.swift
//  ProfileStatus
//
//  Created by Venkata Subbaiah Sama on 27/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit

class ProfileVM: NSObject {
    var files: Observable<File> = Observable()
    
    override init() {
        super.init()
    }
    //Fetches file from Documet manager or server
    func fetchFile(for index: Int) {
        let fileName = String(index)+".jpg"
        let fileModel = File.init(fileNameString: fileName)
        let cached = FileManager.default.checkDocument(forModule: fileName)
        if cached {
            do {
                let localPath = try FileManager.default.getCachedFile(forModule: fileName)
                fileModel.localPath = localPath
                fileModel.downloadInitiated?.value = DocumentStatus.Downloaded
            } catch {
            }
        } else {
            self.getFileFromServer(for: fileModel)
        }
        files.value = fileModel
    }
    //Fetches file from server
    func getFileFromServer(for fileData: File) {
        let fetchAvatar = AvatarFetcher.init()
        fetchAvatar.delegate = self
        fetchAvatar.getFile(forFile: fileData)
    }
}

//All file download URL Session delegates will get notify here
extension ProfileVM: Downloadable {
    //File download finished,
    func download(for document: File, didFinishAt location: URL?, with error: Error?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            var errors = [Error]()
            if error == nil {
                document.downloadStatus?.value = 1
            } else {
                if let error = error {
                    errors.append(error)
                }
                document.errorMessage?.value = error?.localizedDescription
            }
            // on successful finish, we are assigning local file path to File Model
            document.downloadInitiated?.value = DocumentStatus.Finished
            let cached = FileManager.default.checkDocument(forModule: document.fileName)
            if cached {
                do {
                    let localPath = try FileManager.default.getCachedFile(forModule: document.fileName)
                    document.localPath = localPath
                } catch {
                }
            }
            self.files.value = document
        }
    }
    //File being downloading
    func downloadProgress(for document: File, isAt percentCompleted: Float) {
        document.downloadInitiated?.value = DocumentStatus.InProgress
        document.downloadStatus?.value = percentCompleted
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kDownloadProgressNotification), object: document, userInfo: ["info":percentCompleted])

    }
    //File about to start
    func download(willStartFor document: File) {
        document.downloadStatus?.value = 0
        document.downloadInitiated?.value = DocumentStatus.Started
    }
    //File has started
    func download(didStartFor document: File) {
        document.downloadInitiated?.value = DocumentStatus.Started
    }
}
