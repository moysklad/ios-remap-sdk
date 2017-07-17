//
//  MSStatistics.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 17.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public struct MSStatistics: Metable {
    public let context: MSStatisticsContext
    public let meta: MSMeta
    public let data : String
    
    public init(context: MSStatisticsContext,
                meta : MSMeta,
                data : String) {
        self.context = context
        self.meta = meta
        self.data = data
    }
}
