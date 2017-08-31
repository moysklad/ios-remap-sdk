//
//  SimpleDocument.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 01.11.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

public struct MSSimpleDocument: Metable {
    public let meta: MSMeta
    public let id: MSID
    public let accountId: String
    public let shared: Bool
    public let info: MSInfo
    public let moment: Date
    
    public init(meta: MSMeta,
    id: MSID,
    accountId: String,
    shared: Bool,
    info: MSInfo,
    moment: Date) {
        self.meta = meta
        self.id = id
        self.accountId = accountId
        self.shared = shared
        self.info = info
        self.moment = moment
    }

}
