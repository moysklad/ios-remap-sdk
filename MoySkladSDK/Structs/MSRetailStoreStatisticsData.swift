//
//  MSRetailStoreStatisticsData.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 02.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSRetailStoreStatisticsData {
    public let retailShift: MSEntity<MSReportRetailShift>
    public let salesQuantity: Double
    public let salesSum: Money
    public let cashSum: Money
    public let nocashSum: Money
    public let returnsQuantity: Double
    public let returnsSum: Money
    public let retaildrawercashinQuantity: Double
    public let retaildrawercashinSum: Money
    public let retaildrawercashoutQuantity: Double
    public let retaildrawercashoutSum: Money
    public let balance: Money
    public let proceed: Money
    public let profit: Money
    
    init(retailShift: MSEntity<MSReportRetailShift>,
         salesQuantity: Double,
         salesSum: Money,
         cashSum: Money,
         nocashSum: Money,
         returnsQuantity: Double,
         returnsSum: Money,
         retaildrawercashinQuantity: Double,
         retaildrawercashinSum: Money,
         retaildrawercashoutQuantity: Double,
         retaildrawercashoutSum: Money,
         balance: Money,
         proceed: Money,
         profit: Money
    ) {
        self.retailShift = retailShift
        self.salesQuantity = salesQuantity
        self.salesSum = salesSum
        self.cashSum = cashSum
        self.nocashSum = nocashSum
        self.returnsQuantity = returnsQuantity
        self.returnsSum = returnsSum
        self.retaildrawercashinQuantity = retaildrawercashinQuantity
        self.retaildrawercashinSum = retaildrawercashinSum
        self.retaildrawercashoutQuantity = retaildrawercashoutQuantity
        self.retaildrawercashoutSum = retaildrawercashoutSum
        self.balance = balance
        self.proceed = proceed
        self.profit = profit
    }
}
