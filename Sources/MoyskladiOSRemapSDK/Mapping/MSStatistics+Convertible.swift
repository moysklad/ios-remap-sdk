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
        
        return MSEntity.entity(MSStatistics(meta: meta,
                                            series: dict.msArray("series").map { MSStatisticsData.from(dict: $0) }.removeNils()))
    }
    
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        return [:]
    }
}

extension MSStatisticsData {
    public static func from(dict: Dictionary<String, Any>) -> MSStatisticsData? {
        guard let dateServer: String = dict.value("date"), let date = Date.fromMSDate(dateServer) else { return nil }
        
        return MSStatisticsData(moment: date, quantity: dict.value("quantity") ?? 0, sum: Money(minorUnits: dict.value("sum") ?? 0))
    }
}
