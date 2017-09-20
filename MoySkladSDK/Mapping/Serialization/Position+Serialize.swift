//
//  Position+Serialize.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 25.01.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSPosition {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        if meta.href.characters.count > 0 {
            dict["meta"] = meta.dictionary()
        }
        
        guard !metaOnly else { return dict }
        
        if meta.href.characters.count > 0 {
            dict.merge(id.dictionary())
        }
        //dict["accountId"] = accountId
        dict["assortment"] = serialize(entity: assortment, metaOnly: true)
        dict["discount"] = discount
        dict["price"] = price.minorUnits
        dict["quantity"] = quantity
        dict["reserve"] = reserve
        dict["shipped"] = shipped
        dict["vat"] = vat
        dict["country"] = serialize(entity: country, metaOnly: true)
        dict["gtd"] = gtd ?? ""
        
        return dict
    }
}
