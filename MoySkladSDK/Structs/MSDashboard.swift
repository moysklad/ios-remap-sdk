//
//  MSDashboard.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 11.11.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

//import Money

public struct MSDashboard {
    public let sales: MSDashboardSales
    public let orders: MSDashboardOrders
    public let money: MSDashboardMoney
    
    public init( sales: MSDashboardSales,
                 orders: MSDashboardOrders,
                 money: MSDashboardMoney) {
        self.sales = sales
        self.orders = orders
        self.money = money
    }
    
    public static func empty() -> MSDashboard {
        return MSDashboard(sales: MSDashboardSales(count: 0, amount: 0, movementAmount: 0),
                           orders: MSDashboardOrders(count: 0, amount: 0, movementAmount: 0),
                           money: MSDashboardMoney(income: 0, outcome: 0, balance: 0, todayMovement: 0, movement: 0))
    }
}

public struct MSDashboardSales {
    public let count: Int
    public let amount: Money
    public let movementAmount: Money
    
    public init(count: Int,
                amount: Money,
                movementAmount: Money) {
        self.count  = count
        self.amount = amount
        self.movementAmount = movementAmount
    }
}

public struct MSDashboardOrders {
    public let count: Int
    public let amount: Money
    public let movementAmount: Money
    
    public init(count: Int,
                amount: Money,
                movementAmount: Money) {
        self.count = count
        self.amount = amount
        self.movementAmount = movementAmount
    }
}

public struct MSDashboardMoney {
    public let income: Money
    public let outcome: Money
    public let balance: Money
    public let todayMovement: Money
    public let movement: Money
    
    public init(income: Money,
                outcome: Money,
                balance: Money,
                todayMovement: Money,
                movement: Money) {
        self.income = income
        self.outcome = outcome
        self.balance = balance
        self.todayMovement = todayMovement
        self.movement = movement
    }
}
