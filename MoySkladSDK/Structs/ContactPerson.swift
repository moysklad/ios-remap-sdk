//
//  ContactPerson.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 19.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSContactPerson: Metable {
    public var meta: MSMeta
    public var id: MSID
    public var info: MSInfo
    public var accountId: String
    public var externalCode: String
    public var email: String?
    public var phone: String?
    public var position: String?
    public var agent: MSMeta?
    
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
    
    public func copy() -> MSContactPerson {
        return MSContactPerson(meta: meta,
                               id: id,
                               info: info,
                               accountId: accountId,
                               externalCode: externalCode,
                               email: email,
                               phone: phone,
                               position: position,
                               agent: agent)
    }
}
