//
//  ProfileStatusVCTests.swift
//  ProfileStatusTests
//
//  Created by Venkata Subbaiah Sama on 28/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import XCTest
@testable import ProfileStatus

class ProfileStatusVCTests: XCTestCase {

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
    func testProfileModelIsNull() {
        let vc = ProfileStatusVC()
        XCTAssertTrue(vc.profileVM == nil, "Profile View Model should be nil")
    }
    func testFileFetch() {
        let vc = ProfileStatusVC()
        vc.loadAvatarSerial = 1
        vc.profileVM?.fetchFile(for: vc.loadAvatarSerial)
        let profile = ProfileVM()
        profile.fetchFile(for: vc.loadAvatarSerial)
        XCTAssertFalse((vc.profileVM?.files.value)?.fileName == profile.files.value?.fileName, "Profile View Model should be nil")
    }

}
