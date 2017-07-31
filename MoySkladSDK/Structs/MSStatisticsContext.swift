//
//  MSStatisticsContext.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 17.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSStatisticsContext {
    public let employee: MSStatisticsEmployee?
    
    public init(employee: MSStatisticsEmployee?) {
        self.employee = employee
    }
}
