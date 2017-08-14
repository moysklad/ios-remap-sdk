//
//  MSMoneyStatistics+Convertable.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 01.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSMoneyStatistics: DictConvertable {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSMoneyStatistics>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }
        
        return MSEntity.entity(MSMoneyStatistics(meta: meta,
                                                 credit: dict.value("credit") ?? 0, 
                                                 debit: dict.value("debit") ?? 0,
                                                 series: dict.msArray("series").map { MSMoneyStatisticsData.from(dict: $0) }.removeNils()))
    }
    
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        return [:]
    }
}

extension MSMoneyStatisticsData {
    public static func from(dict: Dictionary<String, Any>) -> MSMoneyStatisticsData? {
        guard let dateServer: String = dict.value("date"), let date = Date.fromMSDate(dateServer) else { return nil }
            
        return MSMoneyStatisticsData(moment: date,
                                         credit: Money(minorUnits: dict.value("credit") ?? 0),
                                         debit: Money(minorUnits: dict.value("debit") ?? 0),
                                         balance: Money(minorUnits: dict.value("balance") ?? 0))
    }
}
