//
//  Project.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 24.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

/**
 Represents Project
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#проект)
*/
public struct MSProject : Metable {
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
    
    public init(meta: MSMeta,
    id : MSID,
    info : MSInfo,
    accountId: String,
    owner: MSEntity<MSEmployee>?,
    shared: Bool,
    group: MSEntity<MSGroup>,
    code: String?,
    externalCode: String?,
    archived: Bool) {
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
    }
}
