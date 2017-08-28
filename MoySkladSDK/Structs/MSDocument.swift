//
//  MSDocument.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 28.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSDocument: MSBaseDocumentType, MSGeneralDocument, MSCustomerOrderType, MSDemandType,
                        MSInvoiceOutType, MSInvoiceInType, MSMoneyDocumentType, MSCashInType, MSCashOutType {
    // MSBaseDocumentType
    public var id : MSID
    public var meta : MSMeta
    public var info : MSInfo
    public var agent : MSEntity<MSAgent>?
    public var contract : MSEntity<MSContract>?
    public var sum : Money
    public var vatSum : Money
    public var rate : MSRate?
    public var moment : Date
    public var project : MSEntity<MSProject>?
    public var organization : MSEntity<MSAgent>?
    public var owner : MSEntity<MSEmployee>?
    public var group : MSEntity<MSGroup>
    public var shared : Bool
    public var applicable : Bool
    public var state : MSEntity<MSState>?
    public var attributes : [MSEntity<MSAttribute>]?
    public var originalApplicable: Bool
    
    // MSGeneralDocument
    public var agentAccount : MSEntity<MSAccount>?
    public var organizationAccount : MSEntity<MSAccount>?
    public var vatIncluded : Bool
    public var vatEnabled : Bool
    public var store : MSEntity<MSStore>?
    public var originalStoreId: UUID?
    public var positions : [MSEntity<MSPosition>]
    public var stock : [MSEntity<MSDocumentStock>]
    
    // MSCustomerOrderType
    public var deliveryPlannedMoment : Date?
    public var purchaseOrders : [MSEntity<MSSimpleDocument>]
    public var demands : [MSEntity<MSDemand>]
    public var payments : [MSEntity<MSSimpleDocument>]
    public var invoicesOut : [MSEntity<MSInvoice>]
    
    // MSDemandType
    public var returns: [MSEntity<MSSimpleDocument>]
    public var factureOut: MSEntity<MSSimpleDocument>?
    public var overhead : MSOverhead?
    public var customerOrder : MSEntity<MSCustomerOrder>?
    public var consignee: MSEntity<MSAgent>?
    public var carrier: MSEntity<MSAgent>?
    public var transportFacilityNumber: String?
    public var shippingInstructions: String?
    public var cargoName: String?
    public var transportFacility: String?
    public var goodPackQuantity: Int?
    
    // MSInvoiceOut
    public var paymentPlannedMoment : Date?
    
    // MSInvoiceIn
    public var purchaseOrder: MSEntity<MSSimpleDocument>?
    public var incomingNumber: String?
    public var incomingDate: Date?
    
    // MSMoneyDocumentType
    public var paymentPurpose: String?
    
    // MSCashOutType
    // var expenseItem: Metable
    
    public func copyDocument() -> MSGeneralDocument {
        fatalError()
    }
    
    public func dictionary(metaOnly: Bool) -> [String : Any] {
        fatalError()
    }
    
    public init(id : MSID,
                meta : MSMeta,
                info : MSInfo,
                agent : MSEntity<MSAgent>?,
                contract : MSEntity<MSContract>?,
                sum : Money,
                vatSum : Money,
                rate : MSRate?,
                moment : Date,
                project : MSEntity<MSProject>?,
                organization : MSEntity<MSAgent>?,
                owner : MSEntity<MSEmployee>?,
                group : MSEntity<MSGroup>,
                shared : Bool,
                applicable : Bool,
                state : MSEntity<MSState>?,
                attributes : [MSEntity<MSAttribute>]?,
                originalApplicable: Bool,
                agentAccount : MSEntity<MSAccount>?,
                organizationAccount : MSEntity<MSAccount>?,
                vatIncluded : Bool,
                vatEnabled : Bool,
                store : MSEntity<MSStore>?,
                originalStoreId: UUID?,
                positions : [MSEntity<MSPosition>],
                stock : [MSEntity<MSDocumentStock>],
                deliveryPlannedMoment : Date?,
                purchaseOrders : [MSEntity<MSSimpleDocument>],
                demands : [MSEntity<MSDemand>],
                payments : [MSEntity<MSSimpleDocument>],
                invoicesOut : [MSEntity<MSInvoice>],
                returns: [MSEntity<MSSimpleDocument>],
                factureOut: MSEntity<MSSimpleDocument>?,
                overhead : MSOverhead?,
                customerOrder : MSEntity<MSCustomerOrder>?,
                consignee: MSEntity<MSAgent>?,
                carrier: MSEntity<MSAgent>?,
                transportFacilityNumber: String?,
                shippingInstructions: String?,
                cargoName: String?,
                transportFacility: String?,
                goodPackQuantity: Int?,
                paymentPlannedMoment : Date?,
                purchaseOrder: MSEntity<MSSimpleDocument>?,
                incomingNumber: String?,
                incomingDate: Date?,
                paymentPurpose: String?
        ) {
        self.id = id
        self.meta = meta
        self.info = info
        self.agent = agent
        self.contract = contract
        self.sum = sum
        self.vatSum = vatSum
        self.rate = rate
        self.moment = moment
        self.project = project
        self.organization = organization
        self.owner = owner
        self.group = group
        self.shared = shared
        self.applicable = applicable
        self.state = state
        self.attributes = attributes
        self.originalApplicable = originalApplicable
        self.agentAccount = agentAccount
        self.organizationAccount = organizationAccount
        self.vatIncluded = vatIncluded
        self.vatEnabled = vatEnabled
        self.store = store
        self.originalStoreId = originalStoreId
        self.positions = positions
        self.stock = stock
        self.deliveryPlannedMoment = deliveryPlannedMoment
        self.purchaseOrders = purchaseOrders
        self.demands = demands
        self.payments = payments
        self.invoicesOut = invoicesOut
        self.returns = returns
        self.factureOut = factureOut
        self.overhead = overhead
        self.customerOrder = customerOrder
        self.consignee = consignee
        self.carrier = carrier
        self.transportFacilityNumber = transportFacilityNumber
        self.shippingInstructions = shippingInstructions
        self.cargoName = cargoName
        self.transportFacility = transportFacility
        self.goodPackQuantity = goodPackQuantity
        self.paymentPlannedMoment = paymentPlannedMoment
        self.purchaseOrder = purchaseOrder
        self.incomingNumber = incomingNumber
        self.incomingDate = incomingDate
        self.paymentPurpose = paymentPurpose
    }
}
