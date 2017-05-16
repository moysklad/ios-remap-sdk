//
//  MSEmbeddedTemplate.swift
//  MoySkladSDK
//
//  Created by Vladislav on 10.04.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public struct MSTemplate : Metable {
    public let meta: MSMeta
    public let id : MSID
    public let name : String?
    public init(meta: MSMeta,
                id : MSID,
                name : String?) {
        self.meta = meta
        self.id = id
        self.name = name
    }
}
