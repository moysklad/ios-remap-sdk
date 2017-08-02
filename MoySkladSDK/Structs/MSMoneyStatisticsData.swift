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
    public let credit: Money
    public let debit: Money
    public let balance: Money
    
    public init(moment: Date,
                credit: Money,
                debit: Money,
                balance: Money) {
        self.moment = moment
        self.credit = credit
        self.debit = debit
        self.balance = balance
    }
}
