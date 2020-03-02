//
//  JSONObject.swift
//  ProfileStatus
//
//  Created by Venkata Subbaiah Sama on 25/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

enum JSONValueType: Int {
    case string, number, boolean, date, array, dictionary, null, unknown
}

struct JSONObject {

}

extension JSONObject {
    func stringValue() -> String? {
        return ""
    }
}
