//
//  Types.swift
//  MoyskladNew
//
//  Created by Andrey Parshakov on 14.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

public enum MSObjectType : String {
    case customentity
    case customentitymetadata
    case attributemetadata
	case product
	case productfolder
	case consignment
	case variant
	case store
	case counterparty
	case organization
	case employee
	case companysettings
	case contract
	case project
	case state
	case currency
	case retailstore
	case demand
	case customerorder
	case invoiceout
	case invoicein
	case retailshift
	case retaildemand
	case retailsalesreturn
	case retailcashin
	case retailcashout
	case dashboard
	case stock
	case group
	case account
    case salesreturn
    case invoiceposition
    case customerorderposition
    case purchaseorderposition
    case moveposition
    case demandposition
    case salesreturnposition
    case purchaseorder
    case paymentin
    case paymentout
    case operation
    case cashin
    case cashout
    case service
    case factureout
    case salesbyproduct
    case bundle
    case bundlecomponent
    case embeddedtemplate
    case customtemplate
    case contactperson
    case uom
    case ordersstatistics
    case salesplotseries
    case ordersplotseries
    case moneyplotseries
    case retailstoreshift
    case retailstoreshifts
    case task
    case expenseitem
    case facturein
    case enter
    case supply
    case loss
    case move
    case retaildrawercashin
    case retaildrawercashout
    case purchasereturn
    case inventory
    case internalorder
    case commissionreportin
    case commissionreportout
    case supplyposition
    case inventoryposition
    case country
    case personaldiscount
    case retailshiftsales
    case retailshiftreturns
    case dataexchange
    case notification
}

/// Subset of MSObjectType's for representing documents
public enum MSDocumentType: String {
    case customerorder
    case demand
    case salesreturn
    case invoiceout
    case paymentin
    case paymentout
    case cashin
    case cashout
    case operation
    case supply
    case invoicein
    case purchaseorder
    case purchasereturn
    case move
    case inventory
    case retaildemand
    case retailsalesreturn
    case retaildrawercashin
    case retaildrawercashout
    
    public var isMoneyDocument: Bool {
        switch self {
        case .paymentin, .paymentout, .cashin, .cashout: return true
        default: return false
        }
    }
    
    public var isCashDocument: Bool {
        switch self {
        case .cashin, .cashout: return true
        default: return false
        }
    }
    
    public var isProcurementDocument: Bool {
        switch self {
        case .supply, .purchaseorder, .invoicein: return true
        default: return false
        }
    }
    
    public var objectType: MSObjectType {
        return MSObjectType(rawValue: rawValue)!
    }
    
    public var positionType: MSObjectType? {
        switch self {
        case .customerorder: return .customerorderposition
        case .demand: return .demandposition
        case .invoiceout: return .invoiceposition
        case .supply: return .supplyposition
        case .inventory: return .inventoryposition
        case .paymentin, .paymentout, .cashin, .cashout, .operation, .invoicein, .purchaseorder, .purchasereturn, .move, .retaildrawercashin, .retaildrawercashout, .salesreturn: return nil
        case .retaildemand: return .demandposition
        case .retailsalesreturn: return .salesreturnposition
        }
    }
    
    public static func fromMSObjectType(_ value: MSObjectType) -> MSDocumentType? {
        return MSDocumentType(rawValue: value.rawValue)
    }
}

//конвертер типов с пуша в наш MSObjectType (purpose == task)
public enum MSPushObjectType: String {
    
    case purpose
    case retailshift
    case order
    case customerorder
    case product
    case bundle
    case variant
    case service
    case imports = "import"
    case export
    case invoicein
    case invoiceout
    case good
    case defaultNotification
    
    public var objectType: MSObjectType {
        switch self {
        case .purpose: return .task
        case .retailshift: return .retailshift
        case .order, .customerorder: return .customerorder
        case .product, .bundle, .variant, .service, .good: return .product
        case .imports, .export: return .dataexchange
        case .invoicein: return .invoicein
        case .invoiceout: return .invoiceout
        default: return .notification
        }
    }
}
