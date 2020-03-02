//
//  Constants.swift
//  ProfileStatus
//
//  Created by Venkata Subbaiah Sama on 25/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct urlConstants {
        static let kBaseURL = "https://www.gstatic.com/webp/gallery/"
    }
    static let kDownloadProgressNotification = "DownloadProgressNotification"

}
public struct Units {
    
    public let bytes: Int64
    
    public var kilobytes: Double {
        return Double(bytes) / 1_024
    }
    
    public var megabytes: Double {
        return kilobytes / 1_024
    }
    
    public var gigabytes: Double {
        return megabytes / 1_024
    }
    
    public init(bytes: Int64) {
        self.bytes = bytes
    }
    
    public func getReadableUnit() -> String {
        
        switch bytes {
        case 0..<1_024:
            return "\(bytes) bytes"
        case 1_024..<(1_024 * 1_024):
            return "\(String(format: "%.2f", kilobytes)) kb"
        case 1_024..<(1_024 * 1_024 * 1_024):
            return "\(String(format: "%.2f", megabytes)) mb"
        case (1_024 * 1_024 * 1_024)...Int64.max:
            return "\(String(format: "%.2f", gigabytes)) gb"
        default:
            return "\(bytes) bytes"
        }
    }
}
extension UIColor {
    enum AppColors: Int {
        case red = 0xd0021b
        case green500 = 0x7ed321
        case green600 = 0x4a992e
        case blue = 0x527897
        case blue300 = 0x67aeee
        case blue500 = 0x4a90e2
        case blue600 = 0x2a80b9
        case grey800 = 0x333333
        case orange = 0xe86c16
        case orange500 = 0xfe7d18
        case yellow = 0xfeffdb
        case yellow500 = 0xf2c248
        case purple = 0x7639bd
        case black = 0x000000
        case iOSSeparatorColor = 0xc8c7cc
    }
    
    convenience init(appColor: AppColors) {
        self.init(hex: appColor.rawValue)
    }
    
    convenience init(withShade shade: CGFloat, alpha: CGFloat = 1) {
        let red: CGFloat = shade / 255
        let green: CGFloat = shade / 255
        let blue: CGFloat = shade / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
