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
}

public protocol MSCashInType: MSMoneyDocumentType {
    var incomingDate: Date? { get set }
    var incomingNumber: String? { get set }
}

public protocol MSCashOutType: MSMoneyDocumentType {
    //var expenseItem: Metable { get set }
}
