//
//  MSStock.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 22.11.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

/**
 Represents result from StockAll report.
 See also [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отчёт-остатки-все-остатки-get)
*/
public class MSProductStockAll : Metable {
    public let meta: MSMeta
    public let stock: Double
    public let inTransit: Double
    public let reserve: Double
    public let quantity: Double
    public let name: String
    public let code: String
    public let price: Money
    public let salePrice: Money
    public let externalCode: String
    
    public init(meta: MSMeta,
    stock: Double,
    inTransit: Double,
    reserve: Double,
    quantity: Double,
    name: String,
    code: String,
    price: Money,
    salePrice: Money,
    externalCode: String) {
        self.meta = meta
        self.stock = stock
        self.inTransit = inTransit
        self.reserve = reserve
        self.quantity = quantity
        self.name = name
        self.code = code
        self.price = price
        self.salePrice = salePrice
        self.externalCode = externalCode
    }
}

extension MSProductStockAll {
    public static func empty(id: String? = nil, name: String? = nil, code: String? = nil, externalCode: String? = nil) -> MSProductStockAll {
        return MSProductStockAll(meta: MSMeta(name: "", href: "", type: .product),
            stock: 0,
            inTransit: 0,
            reserve: 0,
            quantity: 0,
            name: name ?? "",
            code: code ?? "",
            price: 0,
            salePrice: 0,
            externalCode: externalCode ?? "")
    }
}

/**
 Represents result from ByStore report.
 See also [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отчёт-остатки-остатки-по-складам-get)
 */
public class MSProductStockStore : Metable {
    public let meta: MSMeta
    public let stock: Double
    public let inTransit: Double
    public let reserve: Double
    public let name: String
    
    public var quantity: Double { return stock + inTransit - reserve }
    
    public init(meta: MSMeta,
    stock: Double,
    inTransit: Double,
    reserve: Double,
    name: String) {
        self.meta = meta
        self.stock = stock
        self.inTransit = inTransit
        self.reserve = reserve
        self.name = name
    }

}

/**
Represents result from StockByOperation report.
See also [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отчёт-остатки-остатки-по-документам-get)
*/
public struct MSDocumentStock : Metable {
    public let meta: MSMeta
    public let stock: Double
    public let inTransit: Double
    public let reserve: Double
    public let quantity: Double
    public let name: String
    public let cost: Money
    
    public init(meta: MSMeta,
    stock: Double,
    inTransit: Double,
    reserve: Double,
    quantity: Double,
    name: String,
        cost: Money) {
        self.meta = meta
        self.stock = stock
        self.inTransit = inTransit
        self.reserve = reserve
        self.quantity = quantity
        self.name = name
        self.cost = cost
    }
}
