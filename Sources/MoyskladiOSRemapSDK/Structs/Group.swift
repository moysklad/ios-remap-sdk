//
//  Group.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 24.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

/**
 Represents Group
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отдел)
*/
public struct MSGroup : Metable {
	public let meta: MSMeta
	public let name: String
    
    public init(meta: MSMeta,
                name: String) {
        self.meta = meta
        self.name = name
    }
}
