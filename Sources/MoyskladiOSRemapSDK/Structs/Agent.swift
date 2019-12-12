//
//  Counterparty.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 24.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

public enum MSCompanyType : String {
	case legal
	case entrepreneur
	case individual
}

public struct MSDiscount: Metable {
    public var meta: MSMeta
    public var personalDiscount: Double
}

public class MSAgentInfo {
	// Organization fields
	public var isEgaisEnable: Bool?
	public var fsrarId: String?
	public var payerVat: Bool
	public var utmUrl: String?
	public var director: String?
	public var chiefAccountant: String?
	
	// Counterparty fields
    public var tags: [String]
    public var contactpersons: [MSEntity<MSContactPerson>]
    public var discounts: [MSDiscount]
    public var state: MSEntity<MSState>?
    public var discountCardNumber: String?
    public var priceType: String?
    
    public init(isEgaisEnable: Bool?,
    fsrarId: String?,
    payerVat: Bool,
    utmUrl: String?,
    director: String?,
    chiefAccountant: String?,
    
    // Counterparty fields
    tags: [String],
    contactpersons: [MSEntity<MSContactPerson>],
    discounts: [MSDiscount],
    state: MSEntity<MSState>?,
    discountCardNumber: String?,
    priceType: String?) {
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
        self.discountCardNumber = discountCardNumber
        self.priceType = priceType
    }
    
    func copy() -> MSAgentInfo {
        return MSAgentInfo(isEgaisEnable: isEgaisEnable,
                           fsrarId: fsrarId,
                           payerVat: payerVat,
                           utmUrl: utmUrl,
                           director: director,
                           chiefAccountant: chiefAccountant,
                           tags: tags,
                           contactpersons: contactpersons,
                           discounts: discounts,
                           state: state,
                           discountCardNumber: discountCardNumber,
                           priceType: priceType)
    }
}

/**
 Represents Counterparty or Organization
 
 For more information, see API reference for [counterparty](https://online.moysklad.ru/api/remap/1.1/doc/index.html#контрагент-контрагенты) and [organization](https://online.moysklad.ru/api/remap/1.1/doc/index.html#юрлицо)
*/
public class MSAgent : MSAttributedEntity, Metable, NSCopying {
	public let meta: MSMeta
	public let id: MSID
	public let accountId: String
	public var owner: MSEntity<MSEmployee>?
	public var shared: Bool
	public var group: MSEntity<MSGroup>
	public var info : MSInfo
	public var code: String?
	public let externalCode: String?
	public var archived: Bool
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
    public var report: MSEntity<MSAgentReport>?
    
    public init(meta: MSMeta,
    id: MSID,
    accountId: String,
    owner: MSEntity<MSEmployee>?,
    shared: Bool,
    group: MSEntity<MSGroup>,
    info : MSInfo,
    code: String?,
    externalCode: String?,
    archived: Bool,
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
    salesAmount: Money,
    attributes: [MSEntity<MSAttribute>]?,
    report: MSEntity<MSAgentReport>?) {
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
        self.report = report
        super.init(attributes: attributes)
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return copyAgent()
    }
    
    public func copyAgent() -> MSAgent {
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
                       agentInfo: agentInfo.copy(),
                       salesAmount: salesAmount,
                       attributes: attributes,
                       report: report)
    }
    
    public func hasChanges(comparedTo other: MSAgent) -> Bool {
        return (try? JSONSerialization.data(withJSONObject: dictionary(metaOnly: false), options: [])) ?? nil ==
            (try? JSONSerialization.data(withJSONObject: other.dictionary(metaOnly: false), options: [])) ?? nil
    }
}
