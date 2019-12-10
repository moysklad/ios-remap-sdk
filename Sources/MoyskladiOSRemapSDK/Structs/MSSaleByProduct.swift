//
//  MSSaleByProduct.swift
//  MoySkladSDK
//
//  Created by Anton Efimenko on 11.01.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

/**
 Represents SalesByModification report result.
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отчёт-прибыльность-прибыльность-по-модификациям-get)
*/
public class MSSaleByModification {
    public let assortment: MSAssortment
    public let sellQuantity: Double
    public let sellPrice: Money
    public let sellCost: Money
    public let sellSum: Money
    public let sellCostSum: Money
    public let returnQuantity: Double
    public let returnPrice: Money
    public let returnCost: Money
    public let returnSum: Money
    public let returnCostSum: Money
    public let profit: Money
    public let margin: Double
    
    public init(assortment: MSAssortment,
                sellQuantity: Double,
                sellPrice: Money,
                sellCost: Money,
                sellSum: Money,
                sellCostSum: Money,
                returnQuantity: Double,
                returnPrice: Money,
                returnCost: Money,
                returnSum: Money,
                returnCostSum: Money,
                profit: Money,
                margin: Double) {
        self.assortment = assortment
        self.sellQuantity = sellQuantity
        self.sellPrice = sellPrice
        self.sellCost = sellCost
        self.sellSum = sellSum
        self.sellCostSum = sellCostSum
        self.returnQuantity = returnQuantity
        self.returnPrice = returnPrice
        self.returnCost = returnCost
        self.returnSum = returnSum
        self.returnCostSum = returnCostSum
        self.profit = profit
        self.margin = margin
    }
}
