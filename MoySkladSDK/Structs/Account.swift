//
//  Account.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 24.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

/**
 Represents Account (related to counterparty or organization).
 Also see API reference for [ counterparty](https://online.moysklad.ru/api/remap/1.1/doc/index.html#контрагент-счета-контрагента-get)
 and [ organizaiton](https://online.moysklad.ru/api/remap/1.1/doc/index.html#юрлицо-счета-юрлица-get)
*/
public class MSAccount : Metable {
	public let meta: MSMeta
	public let id : MSID
	public let info : MSInfo
	public let accountId: String
	public let isDefault: Bool
	public let accountNumber: String
	public let bankName: String?
	public let bankLocation: String?
	public let correspondentAccount: String?
	public let bic: String?
	public let agent: MSMeta?
    
    public init(meta: MSMeta,
    id : MSID,
    info : MSInfo,
    accountId: String,
    isDefault: Bool,
    accountNumber: String,
    bankName: String?,
    bankLocation: String?,
    correspondentAccount: String?,
    bic: String?,
    agent: MSMeta?) {
        self.meta = meta
        self.id  = id
        self.info = info
        self.accountId = accountId
        self.isDefault = isDefault
        self.accountNumber = accountNumber
        self.bankName = bankName
        self.bankLocation = bankLocation
        self.correspondentAccount = correspondentAccount
        self.bic = bic
        self.agent = agent
    }
}
