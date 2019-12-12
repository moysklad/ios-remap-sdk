//
//  MSRetailShiftReportAssortment+Convertable.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 08/11/2018.
//  Copyright © 2018 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSRetailShiftReportAssortment {
    public static func from(dict: Dictionary<String, Any>) -> MSRetailShiftReportAssortment? {
        guard let assortment = MSAssortment.from(dict: dict.msValue("assortment")) else { return nil }
        
        return MSRetailShiftReportAssortment(assortment: assortment,
                                             name: dict.value("name") ?? "",
                                             archived: dict.value("archived") ?? false,
                                             code: dict.value("code") ?? "",
                                             article: dict.value("article") ?? "",
                                             quantity: dict.value("quantity") ?? 0,
                                             uom: MSUOM.from(dict: dict.msValue("uom")),
                                             meanPrice: (dict.value("meanPrice") ?? 0).toMoney(),
                                             discountSum: (dict.value("discountSum") ?? 0).toMoney(),
                                             total: (dict.value("total") ?? 0).toMoney(),
                                             image: MSImage.from(dict: dict.msValue("image")))
    }
}
