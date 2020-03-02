//
//  AvatarFetcher.swift
//  ProfileStatus
//
//  Created by Venkata Subbaiah Sama on 27/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit

class AvatarFetcher {
    var apiClient: NetworkAPIClient?
    weak var delegate: Downloadable?
    
    //Initilize Endpoint to get the File from server
    func getFile(forFile: File) {
        apiClient = NetworkAPIClient.create(baseUrl: Constants.urlConstants.kBaseURL)
        NetworkAPIClient.setSharedClient(apiClient)
        var fileRequest = NetworkRequest(resourcePath: forFile.fileName)
        fileRequest.shouldIgnoreCacheData = true
        let manager = NetworkAPIClient.shared()
        manager?.delegate = delegate
        apiClient?.download(forFile: forFile, request: fileRequest)
    }
}
