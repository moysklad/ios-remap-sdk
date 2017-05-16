//
//  Store.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 24.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

/**
 Represents Store.
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#склад)
*/
public struct MSStore : Metable {
	public let meta: MSMeta
	public let id : MSID
	public let info : MSInfo
	public let accountId: String
	public let owner: MSEntity<MSEmployee>?
	public let shared: Bool
	public let group: MSEntity<MSGroup>
	public let code: String?
	public let externalCode: String?
	public let archived: Bool
	public let address: String?
	public let parent: MSMeta?
	public let pathName: String?
    
    public init(meta: MSMeta,
    id : MSID,
    info : MSInfo,
    accountId: String,
    owner: MSEntity<MSEmployee>?,
    shared: Bool,
    group: MSEntity<MSGroup>,
    code: String?,
    externalCode: String?,
    archived: Bool,
    address: String?,
    parent: MSMeta?,
    pathName: String?) {
        self.meta = meta
        self.id = id
        self.info = info
        self.accountId = accountId
        self.owner = owner
        self.shared = shared
        self.group = group
        self.code = code
        self.externalCode = externalCode
        self.archived = archived
        self.address = address
        self.parent = parent
        self.pathName = pathName
    }
}
