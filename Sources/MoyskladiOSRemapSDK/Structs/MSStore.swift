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
public class MSStore: MSAttributedEntity, Metable {
	public var meta: MSMeta
	public var id : MSID
	public var info : MSInfo
	public var accountId: String
	public var owner: MSEntity<MSEmployee>?
	public var shared: Bool
	public var group: MSEntity<MSGroup>
	public var code: String?
	public var externalCode: String?
	public var archived: Bool
	public var address: String?
	public var parent: MSEntity<MSStore>?
	public var pathName: String?
    
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
    parent: MSEntity<MSStore>?,
    pathName: String?,
    attributes: [MSEntity<MSAttribute>]?) {
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
        super.init(attributes: attributes)
    }
    
    public func hasChanges(comparedTo other: MSStore) -> Bool {
        return (try? JSONSerialization.data(withJSONObject: dictionary(metaOnly: false), options: [])) ?? nil ==
            (try? JSONSerialization.data(withJSONObject: other.dictionary(metaOnly: false), options: [])) ?? nil
    }
    
    public func copy() -> MSStore {
        return MSStore(meta: meta.copy(), id: id.copy(), info: info, accountId: accountId, owner: owner, shared: shared, group: group, code: code, externalCode: externalCode, archived: archived, address: address, parent: parent, pathName: pathName, attributes: attributes)
    }
}
