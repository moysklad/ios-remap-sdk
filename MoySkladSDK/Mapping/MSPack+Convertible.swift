//
//  MSPack+Convertible.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 18.10.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSPack {
    public static func from(dict: Dictionary<String, Any>) -> MSPack {
        return MSPack(id: MSID.init(msID: UUID(uuidString: dict.value("id") ?? ""), syncID: nil),
                      quantity: dict.value("quantity") ?? 0,
                      uom: MSUOM.from(dict: dict.msValue("uom")))
    }
    
    public func dictionary() -> Dictionary<String, Any> {
        var dict = [String:Any]()
        
        dict["id"] = id.msID?.uuidString
        dict["uom"] = uom?.value()?.dictionary(metaOnly: true)
        dict["quantity"] = quantity
        
        return dict
    }
}
