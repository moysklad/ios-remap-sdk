//
//  MSMoneyStatisticsData.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 01.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSMoneyStatisticsData {
    public let moment: Date
    public let credit: Double
    public let debit: Double
    public let balance: Double
    
    public init(moment: Date,
                credit: Double,
                debit: Double,
                balance: Double) {
        self.moment = moment
        self.credit = credit
        self.debit = debit
        self.balance = balance
    }
}
