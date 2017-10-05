//
//  MSCashType.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 24.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public protocol MSMoneyDocumentType : MSBaseDocumentType {
    var paymentPurpose: String? { get set }
    var operations: [MSEntity<MSDocument>] { get set }
    var linkedSum: Money { get set }
    var commitentSum: Money { get set }
}

/**
 Contains properties specific to CashIn
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-приходный-ордер)
 */
public protocol MSCashInType: MSMoneyDocumentType {
    var incomingDate: Date? { get set }
    var incomingNumber: String? { get set }
    var factureOut: MSEntity<MSDocument>? { get set }
}

/**
 Contains properties specific to CashOut
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-расходный-ордер)
 */
public protocol MSCashOutType: MSMoneyDocumentType {
    var expenseItem: MSEntity<MSExpenseItem>? { get set }
    var factureIn: MSEntity<MSDocument>? { get set }
}
