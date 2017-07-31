//
//  MSStatisticsValues.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 17.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSStatisticsValues {
    public let quantity: Double
    public let sum : Double
    
    public init(quantity: Double,
                sum : Double) {
        self.quantity = quantity
        self.sum = sum
    }
}
