//
//  MSCustomEntity.swift
//  MoySkladSDK
//
//  Created by Anton Efimenko on 09.02.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

/**
 Represents Custom entity created by user.
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#пользовательский-справочник)
*/
public class MSCustomEntity : Metable {
    public let meta: MSMeta
    public let id: MSID
    public var name: String
    public var code: String?
    public var externalCode: String?
    public var description: String?
    // идентификатор справочника, которому принадлежит объект
    public var parentId: String
    
    public init(meta: MSMeta, id: MSID, name: String, code: String?, externalCode: String?, description: String?, parentId: String) {
        self.meta = meta
        self.id = id
        self.name = name
        self.code = code
        self.externalCode = externalCode
        self.description = description
        self.parentId = parentId
    }
}
