//
//  ProfileVMTests.swift
//  ProfileStatusTests
//
//  Created by Venkata Subbaiah Sama on 28/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import XCTest
@testable import ProfileStatus

class ProfileVMTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testFileExist() {
        let profile = ProfileVM()
        // Initialize Profile View Model
        profile.fetchFile(for: 1)
        XCTAssertNotNil(profile.files.value, "The profile view model should notbe nil.")
    }
    func testFileModelExist() {
        let file = File(fileNameString: "1.jpg")
        XCTAssertNotNil(file, "The file model should notbe nil.")
    }

    func testFirstFileName() {
        let profile = ProfileVM()
        // Initialize Profile View Model
        profile.fetchFile(for: 1)
        XCTAssertTrue(profile.files.value?.fileName == "1.jpg", "The profile view model first file name should be 1.jpg")
        XCTAssertFalse(profile.files.value?.fileName == "x.jpg", "The profile view model first file name should not be x.jpg")
    }
    func testGetFileFromServer() {
        let profile = ProfileVM()
        let file = File(fileNameString: "1.jpg")
        profile.getFileFromServer(for: file)
        XCTAssertNotNil(profile, "The profile view model should notbe nil.")
    }
    func testDownloadFile() {
        let fetch = AvatarFetcher()
        let file = File(fileNameString: "1.jpg")
        fetch.getFile(forFile: file)
        XCTAssertNotNil(fetch, "The file should notbe nil.")
    }

}
