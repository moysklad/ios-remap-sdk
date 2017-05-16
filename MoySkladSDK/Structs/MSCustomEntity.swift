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
    public let id: String
    public let name: String
    public let code: String?
    public let externalCode: String?
    
    public init(meta: MSMeta, id: String, name: String, code: String?, externalCode: String?) {
        self.meta = meta
        self.id = id
        self.name = name
        self.code = code
        self.externalCode = externalCode
    }
}
