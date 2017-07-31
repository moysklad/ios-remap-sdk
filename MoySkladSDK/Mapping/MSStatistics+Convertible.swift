//
//  MSStatistics+Convertible.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 17.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSStatistics {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSStatistics>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }
        
        return MSEntity.entity(MSStatistics(context: MSStatisticsContext.from(dict: dict.msValue("context")),
                                 meta: meta,
                                 data: MSStatisticsData.from(dict: dict.msArray("data"))))
    }
}

extension MSStatisticsContext {
    public static func from(dict: Dictionary<String, Any>) -> MSStatisticsContext {
        return MSStatisticsContext(employee: MSStatisticsEmployee.from(dict: dict.msValue("employee")))
    }
}

extension MSStatisticsEmployee {
    public static func from(dict: Dictionary<String, Any>) -> MSStatisticsEmployee? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }

        return MSStatisticsEmployee(meta: meta)
    }
}

extension MSStatisticsData {
    public static func from(dict: [Dictionary<String, Any>]) -> Array<MSStatisticsData> {
        var result = Array<MSStatisticsData>()
        dict.forEach { (dataDict) in
            guard let date = (dataDict["date"] as? String)?.toDate() else { return }
            result.append(MSStatisticsData.init(moment: date, values: MSStatisticsValues.from(dict: dataDict.msValue("values"))))
        }
        return result
    }
}

extension MSStatisticsValues {
    public static func from(dict: Dictionary<String, Any>) -> MSStatisticsValues {
        return MSStatisticsValues(quantity: (dict["quantity"] as? Double ?? 0),
                                       sum: (dict["sum"] as? Double ?? 0))
    }
}
