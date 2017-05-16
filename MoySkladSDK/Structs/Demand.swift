//
//  Demand.swift
//  MoyskladNew
//
//  Created by Kostya on 25/10/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

//import Money
import Foundation

/**
 Contains properties specific to Demand
*/
public protocol MSDemandType : MSGeneralDocument {
    var invoicesOut : [MSEntity<MSInvoice>] { get }
    var payments: [MSEntity<MSSimpleDocument>] { get }
    var returns: [MSEntity<MSSimpleDocument>] { get }
    var factureOut: MSEntity<MSSimpleDocument>? { get }
    var overhead : MSOverhead? { get set }
    var customerOrder : MSEntity<MSCustomerOrder>? { get }
    var consignee: MSEntity<MSAgent>? { get set }
    var carrier: MSEntity<MSAgent>? { get set }
    var transportFacilityNumber: String? { get set }
    var shippingInstructions: String? { get set }
    var cargoName: String? { get set }
    var transportFacility: String? { get set }
    var goodPackQuantity: Int? { get set }
}

public enum MSOverheadDistribution : String {
    case weight
    case price
    case volume
}

public struct MSOverhead {
    public var sum: Money
    public var distribution: MSOverheadDistribution
    public init(sum: Money, distribution: MSOverheadDistribution) {
        self.sum = sum
        self.distribution = distribution
    }
}

/**
 Represents Demand.
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-отгрузка)
*/
public class MSDemand : Metable, MSDemandType {
	public let meta : MSMeta
	public let id : MSID
	public let accountId : String
	public var info : MSInfo
	public var code : String?
	public let externalCode : String?
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
	public var agent : MSEntity<MSAgent>?
	public var store : MSEntity<MSStore>?
	public var contract : MSEntity<MSContract>?
	public var project : MSEntity<MSProject>?
	public var state : MSEntity<MSState>?
	public var organizationAccount : MSEntity<MSAccount>?
	public var agentAccount : MSEntity<MSAccount>?
	public var attributes : [MSEntity<MSAttribute>]?
	public var documents : MSMeta?
	public var vatSum : Money
	public var positions : [MSEntity<MSPosition>]
    public var stock : [MSEntity<MSDocumentStock>]
	public var overhead : MSOverhead?
	public var payedSum : Money?
    
    public var consignee: MSEntity<MSAgent>?
    public var carrier: MSEntity<MSAgent>?
    
    public var transportFacilityNumber: String?
    public var shippingInstructions: String?
    public var cargoName: String?
    public var transportFacility: String?
    public var goodPackQuantity: Int?
    
    public var invoicesOut : [MSEntity<MSInvoice>]
    public var payments: [MSEntity<MSSimpleDocument>]
    public var returns: [MSEntity<MSSimpleDocument>]
    public var factureOut: MSEntity<MSSimpleDocument>?
    
    //public let payments: CashIn, PaymentIn
	public var customerOrder: MSEntity<MSCustomerOrder>?
    public let originalStoreId: UUID?
    public let originalApplicable: Bool
    
    public init(meta : MSMeta,
    id : MSID,
    accountId : String,
    info : MSInfo,
    code : String?,
    externalCode : String?,
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
    agent : MSEntity<MSAgent>?,
    store : MSEntity<MSStore>?,
    contract : MSEntity<MSContract>?,
    project : MSEntity<MSProject>?,
    state : MSEntity<MSState>?,
    organizationAccount : MSEntity<MSAccount>?,
    agentAccount : MSEntity<MSAccount>?,
    attributes : [MSEntity<MSAttribute>]?,
    documents : MSMeta?,
    vatSum : Money,
    positions : [MSEntity<MSPosition>],
    stock : [MSEntity<MSDocumentStock>],
    overhead : MSOverhead?,
    payedSum : Money?,
    consignee: MSEntity<MSAgent>?,
    carrier: MSEntity<MSAgent>?,
    transportFacilityNumber: String?,
    shippingInstructions: String?,
    cargoName: String?,
    transportFacility: String?,
    goodPackQuantity: Int?,
    invoicesOut : [MSEntity<MSInvoice>],
    payments: [MSEntity<MSSimpleDocument>],
    returns: [MSEntity<MSSimpleDocument>],
    factureOut: MSEntity<MSSimpleDocument>?,
    customerOrder: MSEntity<MSCustomerOrder>?,
    originalStoreId: UUID?,
    originalApplicable: Bool) {
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
        self.agent = agent
        self.store = store
        self.contract = contract
        self.project = project
        self.state = state
        self.organizationAccount = organizationAccount
        self.agentAccount = agentAccount
        self.attributes = attributes
        self.documents = documents
        self.vatSum = vatSum
        self.positions = positions
        self.stock = stock
        self.overhead = overhead
        self.payedSum = payedSum
        self.consignee = consignee
        self.carrier = carrier
        self.transportFacilityNumber = transportFacilityNumber
        self.shippingInstructions = shippingInstructions
        self.cargoName = cargoName
        self.transportFacility = transportFacility
        self.goodPackQuantity = goodPackQuantity
        self.invoicesOut = invoicesOut
        self.payments = payments
        self.returns = returns
        self.factureOut = factureOut
        self.customerOrder = customerOrder
        self.originalStoreId = originalStoreId
        self.originalApplicable = originalApplicable
    }
    
    public func copy() -> MSDemand {
        let positionsCopy = positions.flatMap { $0.value() }.map { MSEntity.entity($0.copy()) }
        
        return MSDemand(meta: meta,
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
                        agent: agent,
                        store: store,
                        contract: contract,
                        project: project,
                        state: state,
                        organizationAccount: organizationAccount,
                        agentAccount: agentAccount,
                        attributes: attributes,
                        documents: documents,
                        vatSum: vatSum,
                        positions: positionsCopy,
                        stock: stock,
                        overhead: overhead,
                        payedSum: payedSum,
                        consignee: consignee,
                        carrier: carrier,
                        transportFacilityNumber: transportFacilityNumber,
                        shippingInstructions: shippingInstructions,
                        cargoName: cargoName,
                        transportFacility: transportFacility,
                        goodPackQuantity: goodPackQuantity,
                        invoicesOut: invoicesOut,
                        payments: payments,
                        returns: returns,
                        factureOut: factureOut,
                        customerOrder: customerOrder,
                        originalStoreId: originalStoreId,
                        originalApplicable: originalApplicable)
    }
    
    public func copyDocument() -> MSGeneralDocument {
        return copy()
    }
}

