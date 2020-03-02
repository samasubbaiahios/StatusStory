//
//  NetworkAPIClient.swift
//  ProfileStatus
//
//  Created by Venkata Subbaiah Sama on 25/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation

class NetworkAPIClient {
    
    var baseUrl: String
    weak var delegate: Downloadable?

    private static var sharedClient: NetworkAPIClient?
    
    private init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    static func create(baseUrl: String) -> NetworkAPIClient {
        let client = NetworkAPIClient(baseUrl: baseUrl)
        return client
    }
    
    public static func shared() -> NetworkAPIClient? {
        if sharedClient != nil {
            return sharedClient
        }
        return nil
    }
    
    public static func setSharedClient(_ client: NetworkAPIClient?) {
        sharedClient = client
    }
    
    public var baseURL: URL? {
        return URL(string: baseUrl)
    }
    
    func send(request: RequestProtocol, completionCallback: @escaping (ResponseHandler)) {
        NetworkManager.shared().startLoading(request: request, with: completionCallback)
    }
    func download(forFile: File, request: RequestProtocol) {
        let manager = NetworkManager.shared()
        manager.delegate = delegate
        NetworkManager.shared().getFile(request: request, setDocument: forFile)
    }
}
