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
    public var contactpersons: MSMeta?
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
    contactpersons: MSMeta?,
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
    agentInfo: MSAgentInfo) {
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
    }
}


