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
	public var meta: MSMeta
	public var id : MSID
	public var info : MSInfo
	public var accountId: String
	public var isDefault: Bool
	public var accountNumber: String
	public var bankName: String?
	public var bankLocation: String?
	public var correspondentAccount: String?
	public var bic: String?
	public var agent: MSMeta?
    
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
    
    public func copy() -> MSAccount {
        return MSAccount(meta: meta,
                         id: id,
                         info: info,
                         accountId: accountId,
                         isDefault: isDefault,
                         accountNumber: accountNumber,
                         bankName: bankName,
                         bankLocation: bankLocation,
                         correspondentAccount: correspondentAccount,
                         bic: bic,
                         agent: agent)
    }
}
