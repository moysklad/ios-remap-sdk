//
//  Invoices.swift
//  MoyskladNew
//
//  Created by Kostya on 24/10/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

//import Money
import Foundation

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
}

public struct MSInfo {
	public var version : Int
	public var updated : Date?
	public var deleted : Date?
	public var name : String
	public var description : String?
    
    public init(version : Int,
    updated : Date?,
    deleted : Date?,
    name : String,
    description : String?) {
        self.version = version
        self.updated = updated
        self.deleted = deleted
        self.name = name
        self.description = description
    }
}

/**
 Represents Invoice.
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-счёт-покупателю)
*/
public class MSInvoiceInfo {
    // invoiceout
    public var customerOrder: MSEntity<MSCustomerOrder>?
    public var demands: [MSEntity<MSDemand>]
    public var payments: [MSEntity<MSSimpleDocument>]
    
    // invoicein
    public var purchaseOrder: MSEntity<MSSimpleDocument>?
    public var incomingNumber: String?
    public var incomingDate: Date?
    
    public init(customerOrder: MSEntity<MSCustomerOrder>?,
    demands: [MSEntity<MSDemand>],
    payments: [MSEntity<MSSimpleDocument>],
    
    // invoicein
    purchaseOrder: MSEntity<MSSimpleDocument>?,
    incomingNumber: String?,
    incomingDate: Date?) {
        self.customerOrder = customerOrder
        self.demands = demands
        self.payments = payments
        
        // invoicein
        self.purchaseOrder = purchaseOrder
        self.incomingNumber = incomingNumber
        self.incomingDate = incomingDate
    }
    
    public func copy() -> MSInvoiceInfo {
        return MSInvoiceInfo(customerOrder: customerOrder,
                             demands: demands,
                             payments: payments,
                             purchaseOrder: purchaseOrder,
                             incomingNumber: incomingNumber,
                             incomingDate: incomingDate)
    }
}

public protocol MSInvoiceType : MSGeneralDocument {
    var invoiceInfo: MSInvoiceInfo? { get }
    var paymentPlannedMoment : Date? { get set }
}

public protocol MSInvoiceOutType: MSGeneralDocument {
    var paymentPlannedMoment : Date? { get set }
    var customerOrder: MSEntity<MSCustomerOrder>? { get set }
    var demands: [MSEntity<MSDemand>] { get set }
    var payments: [MSEntity<MSSimpleDocument>] { get set }
}

public protocol MSInvoiceInType: MSGeneralDocument {
    var paymentPlannedMoment : Date? { get set }
    var purchaseOrder: MSEntity<MSSimpleDocument>? { get set }
    var incomingNumber: String? { get set }
    var incomingDate: Date? { get set }
}

public class MSInvoice : Metable, MSInvoiceType {
	public let meta : MSMeta
	public let id : MSID
	public let accountId : String
	public var info : MSInfo
	public let externalCode : String
	public var moment : Date
	public var applicable : Bool
	public var vatIncluded : Bool
	public var vatEnabled : Bool
	public var sum : Money
	public var rate : MSRate?
	public var owner : MSEntity<MSEmployee>?
	public var shared : Bool
	public var group : MSEntity<MSGroup>
	public var organization : MSEntity<MSAgent>?
	public var agent : MSEntity<MSAgent>?
	public var store : MSEntity<MSStore>?
	public var contract : MSEntity<MSContract>?
	public var state : MSEntity<MSState>?
	public var organizationAccount : MSEntity<MSAccount>?
	public var agentAccount : MSEntity<MSAccount>?
	public var attributes : [MSEntity<MSAttribute>]?
	//public let documents : MSMeta?
	public var vatSum : Money
	public var positions : [MSEntity<MSPosition>]
    public var stock : [MSEntity<MSDocumentStock>]
	public var paymentPlannedMoment : Date?
	public var payedSum : Money
	public var shippedSum : Money
	public var project : MSEntity<MSProject>?
	public var incomingNumber : String?
	public var incomingDate : Date?
    public var invoiceInfo: MSInvoiceInfo?
    public let originalStoreId: UUID?
    public let originalApplicable: Bool
    
    public init(meta : MSMeta,
    id : MSID,
    accountId : String,
    info : MSInfo,
    externalCode : String,
    moment : Date,
    applicable : Bool,
    vatIncluded : Bool,
    vatEnabled : Bool,
    sum : Money,
    rate : MSRate?,
    owner : MSEntity<MSEmployee>?,
    shared : Bool,
    group : MSEntity<MSGroup>,
    organization : MSEntity<MSAgent>?,
    agent : MSEntity<MSAgent>?,
    store : MSEntity<MSStore>?,
    contract : MSEntity<MSContract>?,
    state : MSEntity<MSState>?,
    organizationAccount : MSEntity<MSAccount>?,
    agentAccount : MSEntity<MSAccount>?,
    attributes : [MSEntity<MSAttribute>]?,
    vatSum : Money,
    positions : [MSEntity<MSPosition>],
    stock : [MSEntity<MSDocumentStock>],
    paymentPlannedMoment : Date?,
    payedSum : Money,
    shippedSum : Money,
    project : MSEntity<MSProject>?,
    incomingNumber : String?,
    incomingDate : Date?,
    invoiceInfo: MSInvoiceInfo?,
    originalStoreId: UUID?,
    originalApplicable: Bool) {
        self.meta = meta
        self.id = id
        self.accountId = accountId
        self.info = info
        self.externalCode = externalCode
        self.moment = moment
        self.applicable = applicable
        self.vatIncluded = vatIncluded
        self.vatEnabled = vatEnabled
        self.sum = sum
        self.rate = rate
        self.owner = owner
        self.shared = shared
        self.group = group
        self.organization = organization
        self.agent = agent
        self.store = store
        self.contract = contract
        self.state = state
        self.organizationAccount = organizationAccount
        self.agentAccount = agentAccount
        self.vatSum = vatSum
        self.positions = positions
        self.stock = stock
        self.paymentPlannedMoment = paymentPlannedMoment
        self.payedSum = payedSum
        self.shippedSum = shippedSum
        self.project = project
        self.incomingNumber = incomingNumber
        self.incomingDate = incomingDate
        self.invoiceInfo = invoiceInfo
        self.attributes = attributes
        self.originalStoreId = originalStoreId
        self.originalApplicable = originalApplicable
    }
    
    public func copy() -> MSInvoice {
        let positionsCopy = positions.flatMap { $0.value() }.map { MSEntity.entity($0.copy()) }
        
        return MSInvoice(meta: meta,
                         id: id,
                         accountId: accountId,
                         info: info,
                         externalCode: externalCode,
                         moment: moment,
                         applicable: applicable,
                         vatIncluded: vatIncluded,
                         vatEnabled: vatEnabled,
                         sum: sum,
                         rate: rate,
                         owner: owner,
                         shared: shared,
                         group: group,
                         organization: organization,
                         agent: agent,
                         store: store,
                         contract: contract,
                         state: state,
                         organizationAccount: organizationAccount,
                         agentAccount: agentAccount,
                         attributes: attributes,
                         vatSum: vatSum,
                         positions: positionsCopy,
                         stock: stock,
                         paymentPlannedMoment: paymentPlannedMoment,
                         payedSum: payedSum,
                         shippedSum: shippedSum,
                         project: project,
                         incomingNumber: incomingNumber,
                         incomingDate: incomingDate,
                         invoiceInfo: invoiceInfo?.copy(),
                         originalStoreId: originalStoreId,
                         originalApplicable: originalApplicable)
    }
    
    public func copyDocument() -> MSGeneralDocument {
        return copy()
    }
}

