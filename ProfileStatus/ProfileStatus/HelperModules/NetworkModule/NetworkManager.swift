//
//  NetworkManager.swift
//  ProfileStatus
//
//  Created by Venkata Subbaiah Sama on 25/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation
import UIKit

typealias ResponseHandler = ((NetworkAPIResponse) -> Void)
typealias DownloadHandler = ((File) -> Void)
typealias finishedHandler = (Bool) -> Void

class NetworkManager: NSObject {
    weak var delegate: Downloadable?

    var document: File?
    var isDownloading = false
    var taskCancelled = false

    private static var sharedManager: NetworkManager!
    public static func shared() -> NetworkManager {
        if let sharedObject = sharedManager {
            return sharedObject
        } else {
            sharedManager = NetworkManager()
            return sharedManager
        }
    }
    
    override private init() {
    }

    func startLoading(request: RequestProtocol, with completionCallback: @escaping (ResponseHandler)) {
//        let urlRequest = URLRequest.withAuthHeader(from: request)
        let urlRequest = URLRequest(request: request)
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 180
        let activeSession = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = activeSession.dataTask(with: urlRequest) { data, urlResponse, error in
            let response = NetworkAPIResponse(request: request, urlResponse: urlResponse, data: data, error: error)
            completionCallback(response)
        }
        task.resume()
        activeSession.finishTasksAndInvalidate()
    }
    func getFile(request: RequestProtocol, setDocument: File) {
        self.document = setDocument
        let urlRequest = URLRequest(request: request)
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 180
        let activeSession = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = activeSession.downloadTask(with: urlRequest)
        if let documentDATA = document {
            delegate?.download(willStartFor: documentDATA)
        }
        task.resume()
        activeSession.finishTasksAndInvalidate()
    }

    
    @discardableResult
    func responseContainsError(_ urlResponse: URLResponse?, error: Error? = nil) -> Bool {
        if let err = error as NSError? {
            if let documentDATA = document {
                delegate?.download(for: documentDATA, didFinishAt: nil, with: err)
            }
            return true
        }
        
        guard let httpResponse = urlResponse as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
                print("httpResponse: \(String(describing: urlResponse))")
                if let documentDATA = document {
                    delegate?.download(for: documentDATA, didFinishAt: nil, with: error)
                }
                return true
        }
        return false
    }

}

extension NetworkManager: URLSessionDelegate {
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print(#function)
        if let sessionId = session.configuration.identifier {
            print("session identifier: \(sessionId), thread: \(Thread.current)")
        }
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, nil)
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let error = error {
            print ("didBecomeInvalidWithError: \(error)")
        }
    }
}

extension NetworkManager: URLSessionDownloadDelegate {

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        isDownloading = false
        
        if responseContainsError(downloadTask.response) || self.taskCancelled == true {
            return
        }
        if let documentDATA = document {
            if let copyToFileURL = documentDATA.storeDownloadedFile(from: location) {
                delegate?.download(for: documentDATA, didFinishAt: copyToFileURL, with: nil)
            } else {
                delegate?.download(for: documentDATA, didFinishAt: nil, with: nil)
            }
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let responseHeaderFields: [AnyHashable: Any]
        
        if let httpResponse = downloadTask.response as? HTTPURLResponse {
            responseHeaderFields = httpResponse.allHeaderFields
            
            let totalSize = Units(bytes: totalBytesExpectedToWrite).getReadableUnit()
            let writtenSize = Units(bytes: totalBytesWritten).getReadableUnit()
            var displayValue = writtenSize+"/"+totalSize
            print(displayValue)
            if totalSize == writtenSize {
                displayValue = "Downloaded"
            }
            var contentLength = Double(totalBytesExpectedToWrite)
            
            if contentLength <= -1, let contentLengthValue = responseHeaderFields["Content-Length"] as? String {
                contentLength = Double(contentLengthValue) ?? 0.0
            }
            
            // Calculate the percent complete
            let dBytesWritten = Double(totalBytesWritten)
            
            // let completed = dBytesWritten / contentLength * 100
            let completed = dBytesWritten / contentLength
            
            if Int(completed) < 5 || !isDownloading {
                isDownloading = true
                if let documentDATA = document {
                    delegate?.download(didStartFor: documentDATA)
                }
            }
            if let documentDATA = document {
                delegate?.downloadProgress(for: documentDATA, isAt: Float(completed))
            }
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print(#function)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        responseContainsError(task.response, error: error)
    }
}
