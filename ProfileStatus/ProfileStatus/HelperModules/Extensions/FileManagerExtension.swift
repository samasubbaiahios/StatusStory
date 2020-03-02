//
//  FileManagerExtension.swift
//  ProfileStatus
//
//  Created by Venkata Subbaiah Sama on 25/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation

extension FileManager {
    func documentDirectoryPath() throws -> String? {
        var docDir: String?
        do {
            let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            docDir = documentsURL.path
        } catch {
            print("could not get docDirPath due to FileManager error: \(error)")
        }
        return docDir
    }
    
    func documentDirectoryURL() throws -> URL {
        var documentDirURL: URL
        
        do {
            documentDirURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
        } catch {
            print("could not get docDirURL due to FileManager error: \(error)")
            throw error
        }
        
        return documentDirURL
    }
    
    func systemCacheDirectoryURL() throws -> URL {
        let cacheDir = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return cacheDir
    }
    
    func cacheFileURL(forFile fileName: String) throws -> URL {
        var jsonDataFileURL: URL
        
        do {
            let docDirURL = try FileManager.default.documentDirectoryURL()
            jsonDataFileURL = docDirURL.appendingPathComponent(fileName)
        } catch {
            print("could not find file due to an error: \(error)")
            throw error
        }
        
        return jsonDataFileURL
    }
    
    func getCachedFile(forModule fileName: String) throws -> URL {
        let moduleCacheFolder: URL
        do {
            let docDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            moduleCacheFolder = docDir.appendingPathComponent(fileName)
        } catch {
            print("could not find file due to an error: \(error)")
            throw error
        }
        
        return moduleCacheFolder
    }
    
    func checkDocument(forModule fileName: String) -> Bool {
        var fileExists: Bool
        var moduleCacheFolder: URL
        do {
            let docDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            moduleCacheFolder = docDir.appendingPathComponent(fileName)
            fileExists = FileManager.default.fileExists(atPath: moduleCacheFolder.path)
        } catch {
            fileExists = false
        }
        return fileExists
    }

}
