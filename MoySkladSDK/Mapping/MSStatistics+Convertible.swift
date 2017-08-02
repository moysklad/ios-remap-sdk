//
//  MSStatistics+Convertible.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 17.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSStatistics: DictConvertable {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSStatistics>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }
        
        return MSEntity.entity(MSStatistics(meta: meta, series: MSStatisticsData.from(dict: dict.msArray("series"))))
    }
    
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        return [:]
    }
}

extension MSStatisticsData {
    public static func from(dict: [Dictionary<String, Any>]) -> Array<MSStatisticsData> {
        var result = Array<MSStatisticsData>()
        dict.forEach { (dataDict) in
            guard let dateServer: String = dataDict.value("date"), let date = dateServer.toDate() else { return }
            
            let item = MSStatisticsData(moment: date, quantity: dataDict.value("quantity") ?? 0, sum: Money(minorUnits: dataDict.value("sum") ?? 0))
            
            result.append(item)
        }
        return result
    }
}
