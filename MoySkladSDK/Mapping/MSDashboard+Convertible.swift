//
//  MSDashboard+Convertible.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 11.11.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation
//import Money

extension MSDashboard {
    public static func from(dict: Dictionary<String, Any>) -> MSDashboard? {
        guard let money = MSDashboardMoney.from(dict: dict.msValue("money")),
            let sales = MSDashboardSales.from(dict: dict.msValue("sales")),
            let orders = MSDashboardOrders.from(dict: dict.msValue("orders")) else {
                return nil
        }
        
        return MSDashboard(sales: sales, orders: orders, money: money)
    }
}

extension MSDashboardMoney {
    public static func from(dict: Dictionary<String, Any>) -> MSDashboardMoney? {
        guard let income: Int = dict.value("income"),
            let outcome: Int = dict.value("outcome"),
            let balance: Int = dict.value("balance"),
            let todayMovement: Int = dict.value("todayMovement"),
            let movement: Int = dict.value("movement") else { return nil }
        
        return MSDashboardMoney(income: Money(minorUnits: income),
                                outcome: Money(minorUnits: outcome),
                                balance: Money(minorUnits: balance),
                                todayMovement: Money(minorUnits: todayMovement),
                                movement: Money(minorUnits: movement))
    }
}

extension MSDashboardOrders {
    public static func from(dict: Dictionary<String, Any>) -> MSDashboardOrders? {
        guard let count: Int = dict.value("count"),
            let amount: Int = dict.value("amount"),
            let movementAmount: Int = dict.value("movementAmount") else {
                return nil
        }

        return MSDashboardOrders(count: count, amount: Money(minorUnits: amount), movementAmount: Money(minorUnits: movementAmount))
    }
}

extension MSDashboardSales {
    public static func from(dict: Dictionary<String, Any>) -> MSDashboardSales? {
        guard let count: Int = dict.value("count"),
            let amount: Int = dict.value("amount"),
            let movementAmount: Int = dict.value("movementAmount") else {
                return nil
        }
        
        return MSDashboardSales(count: count, amount: Money(minorUnits: amount), movementAmount: Money(minorUnits: movementAmount))    }
}
