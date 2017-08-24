//
//  СustomerOrder.swift
//  MoyskladNew
//
//  Created by Kostya on 20/10/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

//import Money
import Foundation

/**
 Contains properties specific to Customer order
*/
public protocol MSCustomerOrderType : MSGeneralDocument {
    var deliveryPlannedMoment : Date? { get set }
    var purchaseOrders : [MSEntity<MSSimpleDocument>] { get }
    var demands : [MSEntity<MSDemand>] { get }
    var payments : [MSEntity<MSSimpleDocument>] { get }
    var invoicesOut : [MSEntity<MSInvoice>] { get }
}

/**
 Represents Customer order
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-заказ-покупателя)
*/
public class MSCustomerOrder : Metable, MSCustomerOrderType {
	public let id : MSID
    public let meta : MSMeta
	public let accountId : String
	public var info : MSInfo
	public let code : String
	public let externalCode : String
	public var archived : Bool
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
	public var organizationAccount : MSEntity<MSAccount>?
	public var agent : MSEntity<MSAgent>?
	public var agentAccount : MSEntity<MSAccount>?
	public var store : MSEntity<MSStore>?
	public var contract : MSEntity<MSContract>?
	public var state : MSEntity<MSState>?
	public var attributes : [MSEntity<MSAttribute>]?
	public var vatSum : Money
	public var positions : [MSEntity<MSPosition>]
    public var stock : [MSEntity<MSDocumentStock>]
	public var reservedSum : Money
	public var deliveryPlannedMoment : Date?
	public var payedSum : Money
	public var shippedSum : Money
	public var invoicedSum : Money
	public var project : MSEntity<MSProject>?
	public var purchaseOrders : [MSEntity<MSSimpleDocument>]
	public var demands : [MSEntity<MSDemand>]
	public var payments : [MSEntity<MSSimpleDocument>]
	public var invoicesOut : [MSEntity<MSInvoice>]
    public let originalStoreId: UUID?
    public let originalApplicable: Bool
    
    public init(meta : MSMeta,
    id : MSID,
    accountId : String,
    info : MSInfo,
    code : String,
    externalCode : String,
    archived : Bool,
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
    organizationAccount : MSEntity<MSAccount>?,
    agent : MSEntity<MSAgent>?,
    agentAccount : MSEntity<MSAccount>?,
    store : MSEntity<MSStore>?,
    contract : MSEntity<MSContract>?,
    state : MSEntity<MSState>?,
    attributes : [MSEntity<MSAttribute>]?,
    vatSum : Money,
    positions : [MSEntity<MSPosition>],
    stock : [MSEntity<MSDocumentStock>],
    reservedSum : Money,
    deliveryPlannedMoment : Date?,
    payedSum : Money,
    shippedSum : Money,
    invoicedSum : Money,
    project : MSEntity<MSProject>?,
    purchaseOrders : [MSEntity<MSSimpleDocument>],
    demands : [MSEntity<MSDemand>],
    payments : [MSEntity<MSSimpleDocument>],
    invoicesOut : [MSEntity<MSInvoice>],
    originalStoreId: UUID?,
    originalApplicable: Bool){
        self.meta = meta
        self.id = id
        self.accountId = accountId
        self.info = info
        self.code = code
        self.externalCode = externalCode
        self.archived = archived
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
        self.organizationAccount = organizationAccount
        self.agent = agent
        self.agentAccount = agentAccount
        self.store = store
        self.contract = contract
        self.state = state
        self.attributes = attributes
        self.vatSum = vatSum
        self.positions = positions
        self.stock = stock
        self.reservedSum = reservedSum
        self.deliveryPlannedMoment = deliveryPlannedMoment
        self.payedSum = payedSum
        self.shippedSum = shippedSum
        self.invoicedSum = invoicedSum
        self.project = project
        self.purchaseOrders = purchaseOrders
        self.demands = demands
        self.payments = payments
        self.invoicesOut = invoicesOut
        self.originalStoreId = originalStoreId
        self.originalApplicable = originalApplicable
    }
    
    public func copy() -> MSCustomerOrder {
        let positionsCopy = positions.flatMap { $0.value() }.map { MSEntity.entity($0.copy()) }
        
        return MSCustomerOrder(meta: meta,
                               id: id,
                               accountId: accountId,
                               info: info,
                               code: code,
                               externalCode: externalCode,
                               archived: archived,
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
                               organizationAccount: organizationAccount,
                               agent: agent,
                               agentAccount: agentAccount,
                               store: store,
                               contract: contract,
                               state: state,
                               attributes: attributes,
                               vatSum: vatSum,
                               positions: positionsCopy,
                               stock: stock,
                               reservedSum: reservedSum,
                               deliveryPlannedMoment: deliveryPlannedMoment,
                               payedSum: payedSum,
                               shippedSum: shippedSum,
                               invoicedSum: invoicedSum,
                               project: project,
                               purchaseOrders: purchaseOrders,
                               demands: demands,
                               payments: payments,
                               invoicesOut: invoicesOut,
                               originalStoreId: originalStoreId,
                               originalApplicable: originalApplicable)
    }
    
    public func copyDocument() -> MSGeneralDocument {
        return copy()
    }
}


