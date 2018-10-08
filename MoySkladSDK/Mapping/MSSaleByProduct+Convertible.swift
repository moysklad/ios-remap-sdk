//
//  MSSaleByProduct+Convertible.swift
//  MoySkladSDK
//
//  Created by Anton Efimenko on 11.01.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSSaleByModification {
    public static func from(dict: Dictionary<String, Any>) -> MSSaleByModification? {
        guard let assortment = MSAssortment.from(dict: dict.msValue("assortment"))?.value() else {
            return nil
        }
        
        return MSSaleByModification(assortment: assortment,
                               sellQuantity: dict.value("sellQuantity") ?? 0,
                               sellPrice: (dict.value("sellPrice") ?? 0.0).toMoney(),
                               sellCost: (dict.value("sellCost") ?? 0.0).toMoney(),
                               sellSum: (dict.value("sellSum") ?? 0.0).toMoney(),
                               sellCostSum: (dict.value("sellCostSum") ?? 0.0).toMoney(),
                               returnQuantity: dict.value("returnQuantity") ?? 0,
                               returnPrice: (dict.value("returnPrice") ?? 0.0).toMoney(),
                               returnCost: (dict.value("returnCost") ?? 0.0).toMoney(),
                               returnSum: (dict.value("returnSum") ?? 0.0).toMoney(),
                               returnCostSum: (dict.value("returnCostSum") ?? 0.0).toMoney(),
                               profit: (dict.value("profit") ?? 0.0).toMoney(),
                               margin: dict.value("margin") ?? 0)
    }
}
