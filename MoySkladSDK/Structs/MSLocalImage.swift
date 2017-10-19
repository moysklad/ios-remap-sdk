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
    public var image: UIImage
    
    public init(title: String,
                image: UIImage) {
        self.title = title
        self.image = image
    }
}
