//
//  MSStatisticsData.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 17.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSStatisticsData {
    public let moment: Date
    public let quantity: Double
    public let sum : Money
    
    public init(moment: Date,
                quantity: Double,
                sum : Money) {
        self.moment = moment
        self.quantity = quantity
        self.sum = sum
    }
}
