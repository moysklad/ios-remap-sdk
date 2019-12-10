//
//  MSInvoiceType.swift
//  MoyskladNew
//
//  Created by Kostya on 24/10/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

/**
 Contains properties specific to Invoice
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-счёт-покупателю)
 */
public protocol MSInvoiceOutType: MSGeneralDocument {
    var paymentPlannedMoment: Date? { get set }
    var customerOrder: MSCustomerOrderType? { get set }
    var demands: [MSDemandType] { get set }
    var payments: [MSEntity<MSDocument>] { get set }
}

public protocol MSInvoiceInType: MSGeneralDocument {
    var paymentPlannedMoment: Date? { get set }
    var purchaseOrder: MSEntity<MSDocument>? { get set }
    var incomingNumber: String? { get set }
    var incomingDate: Date? { get set }
}

public class MSID {
	public let msID: UUID?
	public let syncID: UUID?
	
	public static func empty() -> MSID {
		return MSID(msID: nil, syncID: nil)
	}
    
    public init(msID: UUID?,
         syncID: UUID?) {
        self.msID = msID
        self.syncID = syncID
    }
    
    public func copy() -> MSID {
        return MSID(msID: msID, syncID: syncID)
    }
}

public struct MSInfo {
	public var version: Int
	public var updated: Date?
	public var deleted: Date?
	public var name: String
	public var description: String?
    
    public init(version: Int,
    updated: Date?,
    deleted: Date?,
    name: String,
    description: String?) {
        self.version = version
        self.updated = updated
        self.deleted = deleted
        self.name = name
        self.description = description
    }
}
