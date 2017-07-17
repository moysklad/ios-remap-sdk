//
//  MSStatistics+Convertible.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 17.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSStatistics {
    public static func from(dict: Dictionary<String, Any>) -> MSStatistics? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }
        
        return MSStatistics.init(context: MSStatisticsContext.from(dict: dict.msValue("context")),
                                 meta: meta,
                                 data: [MSStatisticsData.init(moment: Date(), values: [])])
    }
}

extension MSStatisticsContext {
    public static func from(dict: Dictionary<String, Any>) -> MSStatisticsContext? {
        return MSStatisticsContext.from(dict: dict.msValue("employee"))
    }
}

extension MSStatisticsEmployee {
    public static func from(dict: Dictionary<String, Any>) -> MSStatisticsEmployee? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }

        return MSStatisticsEmployee.init(meta: meta)
    }
}
