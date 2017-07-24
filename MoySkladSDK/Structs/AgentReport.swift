//
//  AgentReport.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 20.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSAgentReport: Metable {
    public var meta: MSMeta
    public var agent: MSEntity<MSAgent>
    public var firstDemandDate: Date?
    public var lastDemandDate: Date?
    public var demandsCount: Int
    public var demandsSum: Money
    public var averageReceipt: Money
    public var returnsCount: Int
    public var returnsSum: Money
    public var discountsSum: Money
    public var balance: Money
    public var profit: Money
    public var lastEventDate: Date?
    public var lastEventText: String?
    public var updated: Date?
    
    init(
        meta: MSMeta,
        agent: MSEntity<MSAgent>,
        firstDemandDate: Date?,
        lastDemandDate: Date?,
        demandsCount: Int,
        demandsSum: Money,
        averageReceipt: Money,
        returnsCount: Int,
        returnsSum: Money,
        discountsSum: Money,
        balance: Money,
        profit: Money,
        lastEventDate: Date?,
        lastEventText: String?,
        updated: Date?
    ) {
        self.meta = meta
        self.agent = agent
        self.firstDemandDate = firstDemandDate
        self.lastDemandDate = lastDemandDate
        self.demandsCount = demandsCount
        self.demandsSum = demandsSum
        self.averageReceipt = averageReceipt
        self.returnsCount = returnsCount
        self.returnsSum = returnsSum
        self.discountsSum = discountsSum
        self.balance = balance
        self.profit = profit
        self.lastEventDate = lastEventDate
        self.lastEventText = lastEventText
        self.updated = updated
    }
}
