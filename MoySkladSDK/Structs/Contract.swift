//
//  Contract.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 24.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

//import Money
import Foundation

public enum MSContractType : String {
	case commission
	case sales
}

public enum MSRewardType : String {
	case percentOfSales
	case none
}

/**
 Represents Contract.
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#договор)
*/
public class MSContract : Metable {
	public let meta: MSMeta
	public let id : MSID
	public let info : MSInfo
	public let accountId: String
	public let owner: MSEntity<MSEmployee>?
	public let shared: Bool
	public let group: MSEntity<MSGroup>
	public let code: String?
	public let externalCode: String?
	public let archived: Bool
	public let moment: Date?
	public let sum: Money
	public let contractType: MSContractType?
	public let rewardType: MSRewardType?
	public let rewardPercent: Int?
	public let ownAgent: MSEntity<MSAgent>
	public let agent: MSEntity<MSAgent>?
	public let state: MSEntity<MSState>?
	public let organizationAccount: MSEntity<MSAccount>?
	public let agentAccount: MSEntity<MSAccount>?
	public let rate: MSRate?
    
    public init(meta: MSMeta,
    id : MSID,
    info : MSInfo,
    accountId: String,
    owner: MSEntity<MSEmployee>?,
    shared: Bool,
    group: MSEntity<MSGroup>,
    code: String?,
    externalCode: String?,
    archived: Bool,
    moment: Date?,
    sum: Money,
    contractType: MSContractType?,
    rewardType: MSRewardType?,
    rewardPercent: Int?,
    ownAgent: MSEntity<MSAgent>,
    agent: MSEntity<MSAgent>?,
    state: MSEntity<MSState>?,
    organizationAccount: MSEntity<MSAccount>?,
    agentAccount: MSEntity<MSAccount>?,
    rate: MSRate?) {
        self.meta = meta
        self.id = id
        self.info = info
        self.accountId = accountId
        self.owner = owner
        self.shared = shared
        self.group = group
        self.code = code
        self.externalCode = externalCode
        self.archived = archived
        self.moment = moment
        self.sum = sum
        self.contractType = contractType
        self.rewardType = rewardType
        self.rewardPercent = rewardPercent
        self.ownAgent  = ownAgent
        self.agent  = agent
        self.state = state
        self.organizationAccount = organizationAccount
        self.agentAccount = agentAccount
        self.rate = rate
    }
    
}

