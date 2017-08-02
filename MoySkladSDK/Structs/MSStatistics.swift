//
//  MSStatistics.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 17.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public enum MSStatisticsType: String {
    case orders
    case sales
    case money
}

public class MSStatisticsBase: Metable {
    public let meta: MSMeta
    
    public init(meta: MSMeta) {
        self.meta = meta
    }
}

public class MSStatistics: MSStatisticsBase {
    public let series: Array<MSStatisticsData>
    
    public init(meta: MSMeta,
                series: Array<MSStatisticsData>) {
        self.series = series
        super.init(meta: meta)
    }
}

public class MSMoneyStatistics: MSStatisticsBase {
    public let series: Array<MSMoneyStatisticsData>
    
    public init(meta: MSMeta,
                series: Array<MSMoneyStatisticsData>) {
        self.series = series
        super.init(meta: meta)
    }
}

public class MSRetailStoreStatistics: MSStatisticsBase {
    public let series: Array<MSRetailStoreStatisticsData>
    
    public init(meta: MSMeta,
                series: Array<MSRetailStoreStatisticsData>) {
        self.series = series
        super.init(meta: meta)
    }
}
