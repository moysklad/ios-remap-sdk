//
//  Employee.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 24.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation
import UIKit

/**
 Represents Employee
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#сотрудник)
*/
public class MSEmployee: MSAttributedEntity, Metable {
	public var meta: MSMeta
	public var id : MSID
	public var info : MSInfo
    public var group: MSEntity<MSGroup>
    public var shared: Bool
    public var owner: MSEntity<MSEmployee>?
	public var accountId: String
	public var code: String?
	public var externalCode: String?
	public var archived: Bool
	public var uid: String
    public var inn: String?
	public var email: String?
	public var phone: String?
	public var firstName: String?
	public var middleName: String?
	public var lastName: String
    public var position: String
	public var city: String?
	public var postalAddress: String?
	public var postalCode: String?
	public var fax: String?
	public var icqNumber: String?
	public var skype: String?
	public var fullName: String?
	public var shortFio: String?
	public var cashier: MSMeta?
    public var permissions: MSUserPermissions
    public var image: MSImage?
    public var localImage: MSLocalImage?
    
    public init(meta: MSMeta,
    id : MSID,
    info : MSInfo,
    group: MSEntity<MSGroup>,
    shared: Bool,
    owner: MSEntity<MSEmployee>?,
    accountId: String,
    code: String?,
    externalCode: String?,
    archived: Bool,
    uid: String,
    inn: String?,
    email: String?,
    phone: String?,
    firstName: String?,
    middleName: String?,
    lastName: String,
    position: String,
    city: String?,
    postalAddress: String?,
    postalCode: String?,
    fax: String?,
    icqNumber: String?,
    skype: String?,
    fullName: String?,
    shortFio: String?,
    cashier: MSMeta?,
    permissions: MSUserPermissions,
    image: MSImage?,
    localImage: MSLocalImage?,
    attributes: [MSEntity<MSAttribute>]?) {
        self.meta = meta
        self.id = id
        self.info = info
        self.group = group
        self.shared = shared
        self.owner = owner
        self.accountId = accountId
        self.code = code
        self.externalCode = externalCode
        self.archived = archived
        self.uid = uid
        self.inn = inn
        self.email = email
        self.phone = phone
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.position = position
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
        self.image = image
        self.localImage = localImage
        super.init(attributes: attributes)
    }
    
    public func copy() -> MSEmployee {
        return MSEmployee(meta: meta.copy(), id: id.copy(), info: info, group: group, shared: shared, owner: owner, accountId: accountId, code: code, externalCode: externalCode, archived: archived, uid: uid, inn: inn, email: email, phone: phone, firstName: firstName, middleName: middleName, lastName: lastName, position: position, city: city, postalAddress: postalAddress, postalCode: postalCode, fax: fax, icqNumber: icqNumber, skype: skype, fullName: fullName, shortFio: shortFio, cashier: cashier?.copy(), permissions: permissions, image: image, localImage: localImage, attributes: attributes)
    }
    
    public func hasChanges(comparedTo other: MSEmployee) -> Bool {
        return (try? JSONSerialization.data(withJSONObject: dictionary(metaOnly: false), options: [])) ?? nil ==
            (try? JSONSerialization.data(withJSONObject: other.dictionary(metaOnly: false), options: [])) ?? nil
    }
}
