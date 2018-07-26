//
//  MSDocument.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 28.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSDocument: MSAttributedEntity, MSBaseDocumentType, MSGeneralDocument, MSCustomerOrderType, MSDemandType,
                        MSInvoiceOutType, MSInvoiceInType, MSMoneyDocumentType, MSCashInType, MSCashOutType,
MSPaymentInType, MSPaymentOutType, MSProcurementType, MSSupplyType, MSRetailShiftType, MSMoveType, MSInventoryType, MSRetailType {
    // MSBaseDocumentType
    public var id : MSID
    public var meta : MSMeta
    public var info : MSInfo
    public var agent : MSEntity<MSAgent>?
    public var contract : MSEntity<MSContract>?
    /// Приходит в валюте документа
    public var sum : Money
    public var vatSum : Money
    /// Приходит в валюте учета (валюта по умолчанию для учетной записи)
    public var payedSum: Money
    public var rate : MSRate?
    public var moment : Date
    public var project : MSEntity<MSProject>?
    public var organization : MSEntity<MSAgent>?
    public var owner : MSEntity<MSEmployee>?
    public var group : MSEntity<MSGroup>
    public var shared : Bool
    public var applicable : Bool
    public var state : MSEntity<MSState>?
    public var originalApplicable: Bool
    public var stateContractId: String?
    
    // MSGeneralDocument
    public var agentAccount : MSEntity<MSAccount>?
    public var organizationAccount : MSEntity<MSAccount>?
    public var vatIncluded : Bool
    public var vatEnabled : Bool
    public var store : MSEntity<MSStore>?
    public var originalStoreId: UUID?
    public var positions : [MSEntity<MSPosition>]
    public var totalPositionsCount: Int
    public var stock : [MSEntity<MSDocumentStock>]
    public var positionsManager: ObjectManager<MSPosition>?
    
    // MSCustomerOrderType
    public var deliveryPlannedMoment : Date?
    public var purchaseOrders : [MSEntity<MSDocument>]
    public var demands : [MSDemandType]
    public var payments : [MSEntity<MSDocument>]
    public var invoicesOut : [MSInvoiceOutType]
    
    // MSPurchaseOrderType
    public var customerOrders : [MSEntity<MSDocument>]
    public var supplies : [MSEntity<MSDocument>]
    
    // MSDemandType
    public var returns: [MSEntity<MSDocument>]
    public var factureOut: MSEntity<MSDocument>?
    public var overhead : MSOverhead?
    public var customerOrder : MSCustomerOrderType?
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
    public var purchaseOrder: MSEntity<MSDocument>?
    public var incomingNumber: String?
    public var incomingDate: Date?
    
    // MSMoneyDocumentType
    public var paymentPurpose: String?
    public var factureIn: MSEntity<MSDocument>?
    public var operations: [MSEntity<MSDocument>]
    /// Приходит в валюте связанного документа
    public var linkedSum: Money
    
    // MSCashOutType
    public var expenseItem: MSEntity<MSExpenseItem>?
    
    // MSProcurementType
    public var invoicesIn: [MSEntity<MSDocument>]
    
    // MSRetailShiftType
    public var proceedsNoCash: Money
    public var proceedsCash: Money
    public var receivedNoCash: Money
    public var receivedCash: Money
    
    // commissionreport
    public var commitentSum: Money
    
    // MSMoveType
    public var sourceStore: MSEntity<MSStore>?
    public var targetStore: MSEntity<MSStore>?
    public var internalOrder: MSEntity<MSDocument>?
    public var targetStock: [MSEntity<MSDocumentStock>]
	
	// MSInventoryType
	public var enters: [MSEntity<MSDocument>]
	public var losses: [MSEntity<MSDocument>]
    
    // MSRetailType
    public var retailShift: MSEntity<MSRetailShift>?
    public var cashSum: Money?
    public var noCashSum: Money?
    public var demand: MSEntity<MSDocument>?
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return copyDocument()
    }
    
    public func copyDocument() -> MSDocument {
        let positionsCopy = positions.compactMap { $0.value() }.map { MSEntity.entity($0.copy()) }
        let operationsCopy = operations.compactMap { $0.value() }.map { MSEntity.entity($0.copyDocument()) }

        return MSDocument(id: id,
                          meta: meta,
                          info: info,
                          agent: agent,
                          contract: contract,
                          sum: sum,
                          vatSum: vatSum,
                          payedSum: payedSum,
                          rate: rate,
                          moment: moment,
                          project: project,
                          organization: organization,
                          owner: owner,
                          group: group,
                          shared: shared,
                          applicable: applicable,
                          state: state,
                          attributes: attributes,
                          originalApplicable: originalApplicable,
                          agentAccount: agentAccount,
                          organizationAccount: organizationAccount,
                          vatIncluded: vatIncluded,
                          vatEnabled: vatEnabled,
                          store: store,
                          originalStoreId: originalStoreId,
                          positions: positionsCopy,
                          totalPositionsCount: totalPositionsCount,
                          stock: stock,
                          deliveryPlannedMoment: deliveryPlannedMoment,
                          purchaseOrders: purchaseOrders,
                          demands: demands,
                          payments: payments,
                          invoicesOut: invoicesOut,
                          returns: returns,
                          factureOut: factureOut,
                          overhead: overhead,
                          customerOrder: customerOrder,
                          consignee: consignee,
                          carrier: carrier,
                          transportFacilityNumber: transportFacilityNumber,
                          shippingInstructions: shippingInstructions,
                          cargoName: cargoName,
                          transportFacility: transportFacility,
                          goodPackQuantity: goodPackQuantity,
                          paymentPlannedMoment: paymentPlannedMoment,
                          purchaseOrder: purchaseOrder,
                          incomingNumber: incomingNumber,
                          incomingDate: incomingDate,
                          paymentPurpose: paymentPurpose,
                          factureIn: factureIn,
                          expenseItem: expenseItem,
                          operations: operationsCopy,
                          linkedSum: linkedSum,
                          stateContractId: stateContractId,
                          invoicesIn: invoicesIn,
                          proceedsNoCash: proceedsNoCash,
                          proceedsCash: proceedsCash,
                          receivedNoCash: receivedNoCash,
                          receivedCash: receivedCash,
                          customerOrders: customerOrders,
                          supplies: supplies,
                          commitentSum: commitentSum,
                          sourceStore: sourceStore,
                          targetStore: targetStore,
                          internalOrder: internalOrder,
                          targetStock: targetStock,
						  enters: enters,
						  losses: losses,
                          retailShift: retailShift,
                          cashSum: cashSum,
                          noCashSum: noCashSum,
                          demand: demand,
                          positionsManager: positionsManager?.copy())
    }
    
    public init(id : MSID,
                meta : MSMeta,
                info : MSInfo,
                agent : MSEntity<MSAgent>?,
                contract : MSEntity<MSContract>?,
                sum : Money,
                vatSum : Money,
                payedSum: Money,
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
                totalPositionsCount: Int,
                stock : [MSEntity<MSDocumentStock>],
                deliveryPlannedMoment : Date?,
                purchaseOrders : [MSEntity<MSDocument>],
                demands : [MSDemandType],
                payments : [MSEntity<MSDocument>],
                invoicesOut : [MSInvoiceOutType],
                returns: [MSEntity<MSDocument>],
                factureOut: MSEntity<MSDocument>?,
                overhead : MSOverhead?,
                customerOrder : MSCustomerOrderType?,
                consignee: MSEntity<MSAgent>?,
                carrier: MSEntity<MSAgent>?,
                transportFacilityNumber: String?,
                shippingInstructions: String?,
                cargoName: String?,
                transportFacility: String?,
                goodPackQuantity: Int?,
                paymentPlannedMoment : Date?,
                purchaseOrder: MSEntity<MSDocument>?,
                incomingNumber: String?,
                incomingDate: Date?,
                paymentPurpose: String?,
                factureIn: MSEntity<MSDocument>?,
                expenseItem: MSEntity<MSExpenseItem>?,
                operations: [MSEntity<MSDocument>],
                linkedSum: Money,
                stateContractId: String?,
                invoicesIn: [MSEntity<MSDocument>],
                proceedsNoCash: Money,
                proceedsCash: Money,
                receivedNoCash: Money,
                receivedCash: Money,
                customerOrders: [MSEntity<MSDocument>],
                supplies: [MSEntity<MSDocument>],
                commitentSum: Money,
                sourceStore: MSEntity<MSStore>?,
                targetStore: MSEntity<MSStore>?,
                internalOrder: MSEntity<MSDocument>?,
                targetStock: [MSEntity<MSDocumentStock>],
				enters: [MSEntity<MSDocument>],
				losses: [MSEntity<MSDocument>],
                retailShift: MSEntity<MSRetailShift>?,
                cashSum: Money?,
                noCashSum: Money?,
                demand: MSEntity<MSDocument>?,
                positionsManager: ObjectManager<MSPosition>?) {
        self.id = id
        self.meta = meta
        self.info = info
        self.agent = agent
        self.contract = contract
        self.sum = sum
        self.vatSum = vatSum
        self.payedSum = payedSum
        self.rate = rate
        self.moment = moment
        self.project = project
        self.organization = organization
        self.owner = owner
        self.group = group
        self.shared = shared
        self.applicable = applicable
        self.state = state
        self.originalApplicable = originalApplicable
        self.agentAccount = agentAccount
        self.organizationAccount = organizationAccount
        self.vatIncluded = vatIncluded
        self.vatEnabled = vatEnabled
        self.store = store
        self.originalStoreId = originalStoreId
        self.positions = positions
        self.totalPositionsCount = totalPositionsCount
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
        self.factureIn = factureIn
        self.expenseItem = expenseItem
        self.operations = operations
        self.linkedSum = linkedSum
        self.stateContractId = stateContractId
        self.invoicesIn = invoicesIn
        self.proceedsNoCash = proceedsNoCash
        self.proceedsCash = proceedsCash
        self.receivedNoCash =  receivedNoCash
        self.receivedCash = receivedCash
        self.customerOrders = customerOrders
        self.supplies = supplies
        self.commitentSum = commitentSum
        self.sourceStore = sourceStore
        self.targetStore = targetStore
        self.internalOrder = internalOrder
        self.targetStock = targetStock
		self.enters = enters
		self.losses = losses
        self.retailShift = retailShift
        self.cashSum = cashSum
        self.noCashSum = noCashSum
        self.demand = demand
        self.positionsManager = positionsManager
        super.init(attributes: attributes)
    }
}
