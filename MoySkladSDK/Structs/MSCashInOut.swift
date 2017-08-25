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
    public var contract : MSEntity<MSContract>?
    public var state : MSEntity<MSState>?
    public var attributes : [MSEntity<MSAttribute>]?
    public var vatSum : Money
    public var project : MSEntity<MSProject>?
    public var cashInOutInfo: MSCashInOutInfo?
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
                contract : MSEntity<MSContract>?,
                state : MSEntity<MSState>?,
                attributes : [MSEntity<MSAttribute>]?,
                vatSum : Money,
                project : MSEntity<MSProject>?,
                cashInOutInfo: MSCashInOutInfo?,
                originalApplicable: Bool,
                paymentPurpose: String?) {
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
        self.contract = contract
        self.state = state
        self.vatSum = vatSum
        self.project = project
        self.cashInOutInfo = cashInOutInfo
        self.attributes = attributes
        self.originalApplicable = originalApplicable
        self.paymentPurpose = paymentPurpose
    }
    
    public func copy() -> MSCashInOut {
        return MSCashInOut(meta: meta,
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
                           contract: contract,
                           state: state,
                           attributes: attributes,
                           vatSum: vatSum,
                           project: project,
                           cashInOutInfo: cashInOutInfo,
                           originalApplicable: originalApplicable,
                           paymentPurpose: paymentPurpose)
    }
    
    public func copyDocument() -> MSBaseDocumentType {
        return copy()
    }
}
