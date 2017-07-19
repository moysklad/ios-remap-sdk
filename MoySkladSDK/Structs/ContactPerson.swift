//
//  ContactPerson.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 19.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSContactPerson: Metable {
    public let meta: MSMeta
    public let id: MSID
    public let info: MSInfo
    public let accountId: String
    public let externalCode: String
    public let email: String?
    public let phone: String?
    public let position: String?
    public let agent: MSMeta?
    
    public init(
        meta: MSMeta,
        id: MSID,
        info: MSInfo,
        accountId: String,
        externalCode: String,
        email: String?,
        phone: String?,
        position: String?,
        agent: MSMeta?
    ) {
        self.meta = meta
        self.id = id
        self.info = info
        self.accountId = accountId
        self.externalCode = externalCode
        self.email = email
        self.phone = phone
        self.position = position
        self.agent = agent
    }
}
