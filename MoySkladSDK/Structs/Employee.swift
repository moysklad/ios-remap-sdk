//
//  Employee.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 24.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

/**
 Represents Employee
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#сотрудник)
*/
public struct MSEmployee : Metable {
	public let meta: MSMeta
	public let id : MSID
	public let info : MSInfo
    public let group: MSEntity<MSGroup>
    public let shared: Bool
	public let accountId: String
	public let code: String?
	public let externalCode: String?
	public let archived: Bool
	public let uid: String
	public let email: String?
	public let phone: String?
	public let firstName: String?
	public let middleName: String?
	public let lastName: String
	public let city: String?
	public let postalAddress: String?
	public let postalCode: String?
	public let fax: String?
	public let icqNumber: String?
	public let skype: String?
	public let fullName: String?
	public let shortFio: String?
	public let cashier: MSMeta?
    public let permissions: MSUserPermissions
    
    public init(meta: MSMeta,
    id : MSID,
    info : MSInfo,
    group: MSEntity<MSGroup>,
    shared: Bool, 
    accountId: String,
    code: String?,
    externalCode: String?,
    archived: Bool,
    uid: String,
    email: String?,
    phone: String?,
    firstName: String?,
    middleName: String?,
    lastName: String,
    city: String?,
    postalAddress: String?,
    postalCode: String?,
    fax: String?,
    icqNumber: String?,
    skype: String?,
    fullName: String?,
    shortFio: String?,
    cashier: MSMeta?,
    permissions: MSUserPermissions) {
        self.meta = meta
        self.id = id
        self.info = info
        self.group = group
        self.shared = shared
        self.accountId = accountId
        self.code = code
        self.externalCode = externalCode
        self.archived = archived
        self.uid = uid
        self.email = email
        self.phone = phone
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.city = city
        self.postalAddress = postalAddress
        self.postalCode = postalCode
        self.fax = fax
        self.icqNumber = icqNumber
        self.skype = skype
        self.fullName = fullName
        self.shortFio = shortFio
        self.cashier = cashier
        self.permissions = permissions
    }
}
