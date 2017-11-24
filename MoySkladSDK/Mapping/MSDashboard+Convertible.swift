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
        guard let income: Double = dict.value("income"),
            let outcome: Double = dict.value("outcome"),
            let balance: Double = dict.value("balance"),
            let todayMovement: Double = dict.value("todayMovement"),
            let movement: Double = dict.value("movement") else { return nil }
        
        return MSDashboardMoney(income: income.toMoney(),
                                outcome: outcome.toMoney(),
                                balance: balance.toMoney(),
                                todayMovement: todayMovement.toMoney(),
                                movement: movement.toMoney())
    }
}

extension MSDashboardOrders {
    public static func from(dict: Dictionary<String, Any>) -> MSDashboardOrders? {
        guard let count: Int = dict.value("count"),
            let amount: Double = dict.value("amount"),
            let movementAmount: Double = dict.value("movementAmount") else {
                return nil
        }

        return MSDashboardOrders(count: count, amount: amount.toMoney(), movementAmount: movementAmount.toMoney())
    }
}

extension MSDashboardSales {
    public static func from(dict: Dictionary<String, Any>) -> MSDashboardSales? {
        guard let count: Int = dict.value("count"),
            let amount: Double = dict.value("amount"),
            let movementAmount: Double = dict.value("movementAmount") else {
                return nil
        }
        
        return MSDashboardSales(count: count, amount: amount.toMoney(), movementAmount: movementAmount.toMoney()) }
}
