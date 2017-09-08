//
//  MSExpenseItem.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 30.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSExpenseItem: Metable {
    public var id: MSID
    public var meta: MSMeta
    public var info: MSInfo
    
    public init(id: MSID, meta: MSMeta, info: MSInfo) {
        self.id = id
        self.meta = meta
        self.info = info
    }
}
