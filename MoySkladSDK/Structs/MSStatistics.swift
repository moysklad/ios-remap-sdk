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
}

public class MSStatistics: Metable {
    public let meta: MSMeta
    public let series: Array<MSStatisticsData>
    
    public init(meta : MSMeta,
                series : Array<MSStatisticsData>) {
        self.meta = meta
        self.series = series
    }
}
