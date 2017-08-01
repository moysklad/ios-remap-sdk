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
        
        return MSEntity.entity(MSMoneyStatistics(meta: meta, series: MSMoneyStatisticsData.from(dict: dict.msArray("series"))))
    }
    
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        return [:]
    }
}

extension MSMoneyStatisticsData {
    public static func from(dict: [Dictionary<String, Any>]) -> Array<MSMoneyStatisticsData> {
        var result = Array<MSMoneyStatisticsData>()
        dict.forEach { (dataDict) in
            guard let dateServer: String = dataDict.value("date"), let date = dateServer.toDate() else { return }
            
            let item = MSMoneyStatisticsData(moment: date, credit: dataDict.value("credit") ?? 0, debit: dataDict.value("debit") ?? 0, balance: dataDict.value("balance") ?? 0)
            
            result.append(item)
        }
        return result
    }
}
