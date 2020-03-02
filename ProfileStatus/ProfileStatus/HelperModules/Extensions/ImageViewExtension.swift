//
//  ImageViewExtension.swift
//  ProfileStatus
//
//  Created by Venkata Subbaiah Sama on 26/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// Loads image from URL
    ///
    /// - Parameters:
    ///   - url: An URL would convert to Image data
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    // Convert Image to rounded rect
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.layer.masksToBounds = true;
        self.contentMode = .scaleAspectFill
    }
}
