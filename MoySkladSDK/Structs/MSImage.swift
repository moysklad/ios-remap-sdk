//
//  MSImage.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 20.11.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSImage {
	public let title: String
	public let filename: String
	public let size: UInt
	public let miniatureUrl: URL
	public let tinyUrl: URL?
    
    public init(title: String,
    filename: String,
    size: UInt,
    miniatureUrl: URL,
    tinyUrl: URL?){
        self.title = title
        self.filename = filename
        self.size = size
        self.miniatureUrl = miniatureUrl
        self.tinyUrl = tinyUrl
    }
}
