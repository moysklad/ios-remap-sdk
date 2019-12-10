//
//  MSLocalImage.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 19.10.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import UIKit

public class MSLocalImage {
    public var title: String
    public var minImage: Data
    public var fullImageURL: URL
    
    public init(title: String,
                minImage: Data,
                fullImageURL: URL) {
        self.title = title
        self.minImage = minImage
        self.fullImageURL = fullImageURL
    }
}
