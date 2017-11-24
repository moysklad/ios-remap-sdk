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
            demandsSum: (dict.value("demandsSum") ?? 0.0).toMoney(),
            averageReceipt: (dict.value("averageReceipt") ?? 0.0).toMoney(),
            returnsCount: dict.value("returnsCount") ?? 0,
            returnsSum: (dict.value("returnsSum") ?? 0.0).toMoney(),
            discountsSum: (dict.value("discountsSum") ?? 0.0).toMoney(),
            balance: (dict.value("balance") ?? 0.0).toMoney(),
            profit: (dict.value("profit") ?? 0.0).toMoney(),
            lastEventDate: Date.fromMSDate(dict.value("lastEventDate") ?? ""),
            lastEventText: dict.value("lastEventText"),
            updated: Date.fromMSDate(dict.value("updated") ?? "")
        ))
    }
}
