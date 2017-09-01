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
    case demandposition
    case purchaseorder
    case paymentin
    case paymentout
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
    case task
}
