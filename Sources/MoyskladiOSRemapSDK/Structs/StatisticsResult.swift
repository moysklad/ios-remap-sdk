//
//  StatisticsResult.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 01.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class StatisticsResult {
    public let current: MSEntity<MSStatistics>
    public let last: MSEntity<MSStatistics>
    
    init(current: MSEntity<MSStatistics>, last: MSEntity<MSStatistics>) {
        self.current = current
        self.last = last
    }
}

public class MoneyStatisticsResult {
    public let current: MSEntity<MSMoneyStatistics>
    public let last: MSEntity<MSMoneyStatistics>
    
    public init(current: MSEntity<MSMoneyStatistics>, last: MSEntity<MSMoneyStatistics>) {
        self.current = current
        self.last = last
    }
}
