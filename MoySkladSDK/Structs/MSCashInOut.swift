//
//  MSCashInOut.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 24.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public protocol MSMoneyDocument : MSBaseDocumentType {
    var paymentPurpose: String? { get set }
}

public class MSCashInOutInfo {
    // cash in types
    public var incomingDate: Date?
    public var incomingNumber: String?
    
    // cash out types
//    var expenseItem: Metable { get set }
    public init(incomingDate: Date?,
                incomingNumber: String?) {
        self.incomingDate = incomingDate
        self.incomingNumber = incomingNumber
    }
    
    public func copy() -> MSCashInOutInfo {
        return MSCashInOutInfo(incomingDate: incomingDate, incomingNumber: incomingNumber)
    }
}

public protocol MSCashInOutType : MSMoneyDocument {
    var cashInOutInfo: MSCashInOutInfo? { get }
}

public class MSCashInOut: Metable, MSCashInOutType {
    public func dictionary(metaOnly: Bool) -> [String : Any] {
        return [:]
    }

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
    public var cashInOutInfo: MSCashInOutInfo?
    public let originalStoreId: UUID?
    public let originalApplicable: Bool
    public var paymentPurpose: String?
    
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
                cashInOutInfo: MSCashInOutInfo?,
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
        self.cashInOutInfo = cashInOutInfo
        self.attributes = attributes
        self.originalStoreId = originalStoreId
        self.originalApplicable = originalApplicable
    }
    
    public func copy() -> MSCashInOut {
        return self
//        return MSCashInOut(meta: meta,
//                         id: id,
//                         accountId: accountId,
//                         info: info,
//                         externalCode: externalCode,
//                         moment: moment,
//                         applicable: applicable,
//                         vatIncluded: vatIncluded,
//                         vatEnabled: vatEnabled,
//                         sum: sum,
//                         rate: rate,
//                         owner: owner,
//                         shared: shared,
//                         group: group,
//                         organization: organization,
//                         agent: agent,
//                         store: store,
//                         contract: contract,
//                         state: state,
//                         organizationAccount: organizationAccount,
//                         agentAccount: agentAccount,
//                         attributes: attributes,
//                         vatSum: vatSum,
//                         stock: stock,
//                         paymentPlannedMoment: paymentPlannedMoment,
//                         payedSum: payedSum,
//                         shippedSum: shippedSum,
//                         project: project,
//                         cashInOutInfo: cashInOutInfo?.copy(),
//                         originalStoreId: originalStoreId,
//                         originalApplicable: originalApplicable)
    }
    
//    public func copyDocument() -> MSMoneyDocument {
//        return copy()
//    }
}
