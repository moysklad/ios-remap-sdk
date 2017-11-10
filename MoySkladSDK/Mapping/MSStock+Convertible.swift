//
//  MSStock+Convertible.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 22.11.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

//import Money

extension MSProductStockAll {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSProductStockAll>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
                return nil
        }
        let price: Double = dict.value("price") ?? 0
        return MSEntity.entity(MSProductStockAll(meta: meta,
                                 stock: dict.value("stock") ?? 0,
                                 inTransit: dict.value("inTransit") ?? 0,
                                 reserve: dict.value("reserve") ?? 0,
                                 quantity: dict.value("quantity") ?? 0,
                                 name: dict.value("name") ?? "",
                                 code: dict.value("code") ?? "",
                                 price: Money(minorUnits: Int(price)),
                                 salePrice: Money(minorUnits: dict.value("salePrice") ?? 0),
                                 externalCode: dict.value("externalCode") ?? ""))
    }
}

extension MSProductStockStore {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSProductStockStore>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        return MSEntity.entity(MSProductStockStore(meta: meta,
                                   stock: dict.value("stock") ?? 0,
                                   inTransit: dict.value("inTransit") ?? 0,
                                   reserve: dict.value("reserve") ?? 0,
                                   name: dict.value("name") ?? ""))
    }
}

extension MSDocumentStock {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSDocumentStock>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        return MSEntity.entity(MSDocumentStock(meta: meta,
                                               stock:dict.value("stock") ?? 0,
                                               inTransit: dict.value("inTransit") ?? 0,
                                               reserve: dict.value("reserve") ?? 0,
                                               quantity: dict.value("quantity") ?? 0,
                                               name: dict.value("name") ?? "",
                                               cost: Money(minorUnits: dict.value("cost") ?? 0)))
    }
}
