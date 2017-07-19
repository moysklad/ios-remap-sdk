//
//  Counterparty.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 24.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

public protocol MSGeneralCounterparty : class, Metable {
    var meta: MSMeta { get }
    var id: MSID { get }
    var accountId: String { get }
    var owner: MSEntity<MSEmployee>? { get set }
    var shared: Bool { get }
    var group: MSEntity<MSGroup> { get set }
    var info : MSInfo { get set }
    var code: String? { get set }
    var externalCode: String? { get }
    var archived: Bool? { get }
    var actualAddress: String? { get set }
    var companyType: MSCompanyType { get set }
    var email: String? { get set }
    var phone: String? { get set }
    var fax: String? { get set }
    var legalTitle: String? { get set }
    var legalAddress: String? { get set }
    var inn: String? { get set }
    var kpp: String? { get set }
    var ogrn: String? { get set }
    var ogrnip: String? { get set }
    var okpo: String? { get set }
    var certificateNumber: String? { get set }
    var certificateDate: Date? { get set }
    var accounts: [MSEntity<MSAccount>] { get set }
    var agentInfo: MSAgentInfo { get set }
    var salesAmount: Money { get }
    func copyAgent() -> MSGeneralCounterparty
    func dictionary(metaOnly: Bool) -> [String: Any]
}

public enum MSCompanyType : String {
	case legal
	case entrepreneur
	case individual
}

public class MSAgentInfo {
	// Organization fields
	public let isEgaisEnable: Bool?
	public let fsrarId: String?
	public let payerVat: Bool
	public let utmUrl: String?
	public let director: String?
	public let chiefAccountant: String?
	
	// Counterparty fields
    public var tags: [String]
    public var contactpersons: [MSEntity<MSContactPerson>]
    public var discounts: MSMeta?
    public var state: MSEntity<MSState>?
    
    public init(isEgaisEnable: Bool?,
    fsrarId: String?,
    payerVat: Bool,
    utmUrl: String?,
    director: String?,
    chiefAccountant: String?,
    
    // Counterparty fields
    tags: [String],
    contactpersons: [MSEntity<MSContactPerson>],
    discounts: MSMeta?,
    state: MSEntity<MSState>?) {
        self.isEgaisEnable = isEgaisEnable
        self.fsrarId = fsrarId
        self.payerVat = payerVat
        self.utmUrl = utmUrl
        self.director = director
        self.chiefAccountant = chiefAccountant
        
        // Counterparty fields
        self.tags = tags
        self.contactpersons = contactpersons
        self.discounts = discounts
        self.state = state
    
    }
}

/**
 Represents Counterparty or Organization
 
 For more information, see API reference for [counterparty](https://online.moysklad.ru/api/remap/1.1/doc/index.html#контрагент-контрагенты) and [organization](https://online.moysklad.ru/api/remap/1.1/doc/index.html#юрлицо)
*/
public class MSAgent : Metable {
	public let meta: MSMeta
	public let id: MSID
	public let accountId: String
	public var owner: MSEntity<MSEmployee>?
	public let shared: Bool
	public var group: MSEntity<MSGroup>
	public var info : MSInfo
	public var code: String?
	public let externalCode: String?
	public let archived: Bool?
	public var actualAddress: String?
	public var companyType: MSCompanyType
	public var email: String?
	public var phone: String?
	public var fax: String?
	public var legalTitle: String?
	public var legalAddress: String?
	public var inn: String?
	public var kpp: String?
	public var ogrn: String?
	public var ogrnip: String?
	public var okpo: String?
	public var certificateNumber: String?
	public var certificateDate: Date?
	public var accounts: [MSEntity<MSAccount>]
	public var agentInfo: MSAgentInfo
    public var salesAmount: Money
    
    public init(meta: MSMeta,
    id: MSID,
    accountId: String,
    owner: MSEntity<MSEmployee>?,
    shared: Bool,
    group: MSEntity<MSGroup>,
    info : MSInfo,
    code: String?,
    externalCode: String?,
    archived: Bool?,
    actualAddress: String?,
    companyType: MSCompanyType,
    email: String?,
    phone: String?,
    fax: String?,
    legalTitle: String?,
    legalAddress: String?,
    inn: String?,
    kpp: String?,
    ogrn: String?,
    ogrnip: String?,
    okpo: String?,
    certificateNumber: String?,
    certificateDate: Date?,
    accounts: [MSEntity<MSAccount>],
    agentInfo: MSAgentInfo,
    salesAmount: Money) {
        self.meta = meta
        self.id = id
        self.accountId = accountId
        self.owner = owner
        self.shared = shared
        self.group = group
        self.info = info
        self.code = code
        self.externalCode = externalCode
        self.archived = archived
        self.actualAddress = actualAddress
        self.companyType = companyType
        self.email = email
        self.phone = phone
        self.fax = fax
        self.legalTitle = legalTitle
        self.legalAddress = legalAddress
        self.inn = inn
        self.kpp = kpp
        self.ogrn = ogrn
        self.ogrnip = ogrnip
        self.okpo = okpo
        self.certificateNumber = certificateNumber
        self.certificateDate = certificateDate
        self.accounts = accounts
        self.agentInfo = agentInfo
        self.salesAmount = salesAmount
    }
    
    public func copy() -> MSAgent {
        return MSAgent(meta: meta,
                       id: id,
                       accountId: accountId,
                       owner: owner,
                       shared: shared,
                       group: group,
                       info : info,
                       code: code,
                       externalCode: externalCode,
                       archived: archived,
                       actualAddress: actualAddress,
                       companyType: companyType,
                       email: email,
                       phone: phone,
                       fax: fax,
                       legalTitle: legalTitle,
                       legalAddress: legalAddress,
                       inn: inn,
                       kpp: kpp,
                       ogrn: ogrn,
                       ogrnip: ogrnip,
                       okpo: okpo,
                       certificateNumber: certificateNumber,
                       certificateDate: certificateDate,
                       accounts: accounts,
                       agentInfo: agentInfo,
                       salesAmount: salesAmount)
    }
    
    public func copyAgent() -> MSAgent {
        return copy()
    }
}


