//
//  StatisticsResult.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 01.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class StatisticsResult {
    let current: MSEntity<MSStatistics>
    let last: MSEntity<MSStatistics>
    
    init(current: MSEntity<MSStatistics>, last: MSEntity<MSStatistics>) {
        self.current = current
        self.last = last
    }
}
