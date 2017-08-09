//
//  MSRetailStoreStatistics+Convertable.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 02.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSRetailStoreStatistics: DictConvertable {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSRetailStoreStatistics>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }
        
        return MSEntity.entity(MSRetailStoreStatistics(meta: meta,
                                                       series: dict.msArray("series").map { MSRetailStoreStatisticsData.from(dict: $0) }.removeNils()))
    }
    
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        return [:]
    }
}

extension MSRetailStoreStatisticsData {
    public static func from(dict: Dictionary<String, Any>) -> MSRetailStoreStatisticsData? {
        guard let retailShift = MSRetailShift.from(dict: dict.msValue("retailShift")) else { return nil }
        
        return MSRetailStoreStatisticsData(
            retailShift: retailShift,
            salesQuantity: dict.value("salesQuantity") ?? 0,
            salesSum: Money(minorUnits: dict.value("salesSum") ?? 0),
            cashSum: Money(minorUnits: dict.value("cashSum") ?? 0),
            nocashSum: Money(minorUnits: dict.value("nocashSum") ?? 0),
            returnsQuantity: dict.value("returnsQuantity") ?? 0,
            returnsSum: Money(minorUnits: dict.value("returnsSum") ?? 0),
            retaildrawercashinQuantity: dict.value("retaildrawercashinQuantity") ?? 0,
            retaildrawercashinSum: Money(minorUnits: dict.value("retaildrawercashinSum") ?? 0),
            retaildrawercashoutQuantity: dict.value("retaildrawercashoutQuantity") ?? 0,
            retaildrawercashoutSum: Money(minorUnits: dict.value("retaildrawercashoutSum") ?? 0),
            balance: Money(minorUnits: dict.value("balance") ?? 0),
            proceed: Money(minorUnits: dict.value("proceed") ?? 0),
            profit: Money(minorUnits: dict.value("profit") ?? 0))
    }
}
