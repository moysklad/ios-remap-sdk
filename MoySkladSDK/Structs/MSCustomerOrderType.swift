//
//  MSCustomerOrderType.swift
//  MoyskladNew
//
//  Created by Kostya on 20/10/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

/**
 Contains properties specific to Customer order
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-заказ-покупателя)
*/
public protocol MSCustomerOrderType : MSGeneralDocument {
    var deliveryPlannedMoment : Date? { get set }
    var purchaseOrders : [MSEntity<MSDocument>] { get }
    var demands : [MSDemandType] { get }
    var payments : [MSEntity<MSDocument>] { get }
    var invoicesOut : [MSInvoiceOutType] { get }
}
