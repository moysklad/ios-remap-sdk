//
//  AgentReport.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 20.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSAgentReport: Metable {
    public let meta: MSMeta
    public let agent: MSEntity<MSAgent>
    public let firstDemandDate: Date?
    public let lastDemandDate: Date?
    public let demandsCount: Int
    public let demandsSum: Money
    public let averageReceipt: Money
    public let returnsCount: Int
    public let returnsSum: Money
    public let discountsSum: Money
    public let balance: Money
    public let profit: Money
    public let lastEventDate: Date?
    public let lastEventText: String?
    public let updated: Date?
    
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
