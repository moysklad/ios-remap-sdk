//
//  MSPaymentType.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 30.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

/**
 Contains properties specific to PaymentIn
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-входящий-платеж)
 */
public protocol MSPaymentInType: MSMoneyDocumentType {
    var incomingDate: Date? { get set }
    var incomingNumber: String? { get set }
    var factureOut: MSEntity<MSDocument>? { get set }
}

/**
 Contains properties specific to PaymentOut
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-исходящий-платеж)
 */
public protocol MSPaymentOutType: MSMoneyDocumentType {
    var expenseItem: MSEntity<MSExpenseItem>? { get set }
    var factureIn: MSEntity<MSDocument>? { get set }
}
