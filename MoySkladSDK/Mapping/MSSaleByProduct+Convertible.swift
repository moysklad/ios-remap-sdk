//
//  MSSaleByProduct+Convertible.swift
//  MoySkladSDK
//
//  Created by Anton Efimenko on 11.01.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSSaleByProduct {
    public static func from(dict: Dictionary<String, Any>) -> MSSaleByProduct? {
        guard let assortment = MSAssortment.from(dict: dict.msValue("assortment"))?.value() else {
            return nil
        }
        
        return MSSaleByProduct(assortment: assortment,
                               sellQuantity: dict.value("sellQuantity") ?? 0,
                               sellPrice: Money(minorUnits: dict.value("sellPrice") ?? 0),
                               sellCost: Money(minorUnits: dict.value("sellCost") ?? 0),
                               sellSum: Money(minorUnits: dict.value("sellSum") ?? 0),
                               sellCostSum: Money(minorUnits: dict.value("sellCostSum") ?? 0),
                               returnQuantity: dict.value("returnQuantity") ?? 0,
                               returnPrice: Money(minorUnits: dict.value("returnPrice") ?? 0),
                               returnCost: Money(minorUnits: dict.value("returnCost") ?? 0),
                               returnSum: Money(minorUnits: dict.value("returnSum") ?? 0),
                               returnCostSum: Money(minorUnits: dict.value("returnCostSum") ?? 0),
                               profit: Money(minorUnits: dict.value("profit") ?? 0),
                               margin: dict.value("margin") ?? 0)
    }
}
