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
        guard let retailShift = MSReportRetailShift.from(dict: dict.msValue("retailShift")) else { return nil }
        
        return MSRetailStoreStatisticsData(
            retailShift: retailShift,
            salesQuantity: dict.value("salesQuantity") ?? 0,
            salesSum: (dict.value("salesSum") ?? 0.0).toMoney(),
            cashSum: (dict.value("cashSum") ?? 0.0).toMoney(),
            nocashSum: (dict.value("nocashSum") ?? 0.0).toMoney(),
            returnsQuantity: dict.value("returnsQuantity") ?? 0,
            returnsSum: (dict.value("returnsSum") ?? 0.0).toMoney(),
            retaildrawercashinQuantity: dict.value("retaildrawercashinQuantity") ?? 0,
            retaildrawercashinSum: (dict.value("retaildrawercashinSum") ?? 0.0).toMoney(),
            retaildrawercashoutQuantity: dict.value("retaildrawercashoutQuantity") ?? 0,
            retaildrawercashoutSum: (dict.value("retaildrawercashoutSum") ?? 0.0).toMoney(),
            balance: (dict.value("balance") ?? 0.0).toMoney(),
            proceed: (dict.value("proceed") ?? 0.0).toMoney(),
            profit: (dict.value("profit") ?? 0.0).toMoney())
    }
}
