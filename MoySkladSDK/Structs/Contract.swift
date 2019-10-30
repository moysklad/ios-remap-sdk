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
	case commission = "Commission"
	case sales = "Sales"
}

public enum MSRewardType : String {
	case percentOfSales = "PercentOfSales"
	case none = "None"
}

/**
 Represents Contract.
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#договор)
*/
public class MSContract: MSAttributedEntity, Metable {
	public var meta: MSMeta
	public var id : MSID
	public var info : MSInfo
	public var accountId: String
	public var owner: MSEntity<MSEmployee>?
	public var shared: Bool
	public var group: MSEntity<MSGroup>
	public var code: String?
	public var externalCode: String?
	public var archived: Bool
	public var moment: Date?
	public var sum: Money
	public var contractType: MSContractType?
	public var rewardType: MSRewardType?
	public var rewardPercent: Int?
	public var ownAgent: MSEntity<MSAgent>?
	public var agent: MSEntity<MSAgent>?
	public var state: MSEntity<MSState>?
	public var organizationAccount: MSEntity<MSAccount>?
	public var agentAccount: MSEntity<MSAccount>?
	public var rate: MSRate?
    
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
    ownAgent: MSEntity<MSAgent>?,
    agent: MSEntity<MSAgent>?,
    state: MSEntity<MSState>?,
    organizationAccount: MSEntity<MSAccount>?,
    agentAccount: MSEntity<MSAccount>?,
    rate: MSRate?,
    attributes: [MSEntity<MSAttribute>]?) {
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
        super.init(attributes: attributes)
    }
    
    public func copy() -> MSContract {
        return MSContract(meta: meta.copy(), id: id.copy(), info: info, accountId: accountId, owner: owner, shared: shared, group: group, code: code, externalCode: externalCode, archived: archived, moment: moment, sum: sum, contractType: contractType, rewardType: rewardType, rewardPercent: rewardPercent, ownAgent: ownAgent, agent: agent, state: state, organizationAccount: organizationAccount, agentAccount: agentAccount, rate: rate, attributes: attributes)
    }
    
    public func hasChanges(comparedTo other: MSContract) -> Bool {
        return (try? JSONSerialization.data(withJSONObject: dictionary(metaOnly: false), options: [])) ?? nil ==
            (try? JSONSerialization.data(withJSONObject: other.dictionary(metaOnly: false), options: [])) ?? nil
    }

}
