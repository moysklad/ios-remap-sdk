//
//  MSStatisticsData.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 17.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public struct MSStatisticsData {
    public let moment: Date
    public let values : MSStatisticsValues
    
    public init(moment: Date,
                values : MSStatisticsValues) {
        self.moment = moment
        self.values = values
    }
}
