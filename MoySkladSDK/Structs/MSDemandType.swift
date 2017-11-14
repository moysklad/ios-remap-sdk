//
//  MSDemandType.swift
//  MoyskladNew
//
//  Created by Kostya on 25/10/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

/**
 Contains properties specific to Demand
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-отгрузка)
*/
public protocol MSDemandType : MSGeneralDocument {
    var invoicesOut : [MSInvoiceOutType] { get }
    var payments: [MSEntity<MSDocument>] { get }
    var returns: [MSEntity<MSDocument>] { get }
    var factureOut: MSEntity<MSDocument>? { get }
    var overhead : MSOverhead? { get set }
    var customerOrder : MSCustomerOrderType? { get }
    var consignee: MSEntity<MSAgent>? { get set }
    var carrier: MSEntity<MSAgent>? { get set }
    var transportFacilityNumber: String? { get set }
    var shippingInstructions: String? { get set }
    var cargoName: String? { get set }
    var transportFacility: String? { get set }
    var goodPackQuantity: Int? { get set }
}

public enum MSOverheadDistribution : String {
    case weight
    case price
    case volume
}

public struct MSOverhead {
    public var sum: Money
    public var distribution: MSOverheadDistribution
    public init(sum: Money, distribution: MSOverheadDistribution) {
        self.sum = sum
        self.distribution = distribution
    }
}

public struct MSBundleOverhead {
    public var value: Money
    public var currency: MSEntity<MSCurrency>
    public init(value: Money, currency: MSEntity<MSCurrency>) {
        self.value = value
        self.currency = currency
    }
}
