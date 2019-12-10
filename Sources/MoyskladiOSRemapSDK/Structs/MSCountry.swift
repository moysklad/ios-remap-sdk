//
//  MSCountry.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 20.09.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSCountry: Metable {
    public let meta: MSMeta
    public let id: MSID
    public var info: MSInfo
    public let code: String?
    public let externalCode: String?
    
    public init(meta: MSMeta, id: MSID, info: MSInfo, code: String?, externalCode: String?) {
        self.meta = meta
        self.id = id
        self.info = info
        self.externalCode = externalCode
        self.code = code
    }
}
