//
//  MSRetailShiftReportAssortment.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 08/11/2018.
//  Copyright © 2018 Andrey Parshakov. All rights reserved.
//

import Foundation

public struct MSRetailShiftReportAssortment {
    public let assortment: MSEntity<MSAssortment>
    public let name: String
    public let archived: Bool
    public let code: String
    public let article: String
    public let quantity: Double
    public let uom: MSEntity<MSUOM>?
    public let meanPrice: Money
    public let discountSum: Money
    public let total: Money
    public let image: MSImage?

    public func changed(name: String, code: String, article: String, image: MSImage?) -> MSRetailShiftReportAssortment {
        return MSRetailShiftReportAssortment(assortment: self.assortment, name: name, archived: self.archived, code: code, article: article, quantity: self.quantity, uom: self.uom, meanPrice: self.meanPrice, discountSum: self.discountSum, total: self.total, image: image)
    }
}
