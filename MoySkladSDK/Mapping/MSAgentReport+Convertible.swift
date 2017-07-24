//
//  MSAgentReport+Convertible.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 20.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSAgentReport: DictConvertable {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        return [String:Any]()
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSAgentReport>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict), let agent = MSAgent.from(dict: dict.msValue("counterparty")) else { return nil }
        
        return MSEntity.entity(MSAgentReport(
            meta: meta,
            agent: agent,
            firstDemandDate: Date.fromMSDate(dict.value("firstDemandDate") ?? ""),
            lastDemandDate: Date.fromMSDate(dict.value("lastDemandDate") ?? ""),
            demandsCount: dict.value("demandsCount") ?? 0,
            demandsSum: Money(minorUnits: dict.value("demandsSum") ?? 0),
            averageReceipt: Money(minorUnits: dict.value("averageReceipt") ?? 0),
            returnsCount: dict.value("returnsCount") ?? 0,
            returnsSum: Money(minorUnits: dict.value("returnsSum") ?? 0),
            discountsSum: Money(minorUnits: dict.value("discountsSum") ?? 0),
            balance: Money(minorUnits: dict.value("balance") ?? 0),
            profit: Money(minorUnits: dict.value("profit") ?? 0),
            lastEventDate: Date.fromMSDate(dict.value("lastEventDate") ?? ""),
            lastEventText: dict.value("lastEventText"),
            updated: Date.fromMSDate(dict.value("updated") ?? "")
        ))
    }
}
