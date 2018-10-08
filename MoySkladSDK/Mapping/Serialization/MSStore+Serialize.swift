//
//  MSStore+Serialize.swift
//  MoyskladiOSRemapSDK
//
//  Created by Антон Ефименко on 21.09.2018.
//  Copyright © 2018 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSStore {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        if meta.href.count > 0 {
            dict["meta"] = meta.dictionary()
        }
        
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        
        dict["owner"] = serialize(entity: owner, metaOnly: metaOnly)
        dict["shared"] = shared
        dict["group"] = serialize(entity: group, metaOnly: metaOnly)
        dict["code"] = code
        dict["externalCode"] = externalCode ?? ""
        dict["archived"] = archived
        dict["address"] = address ?? ""
        dict["pathName"] = pathName ?? ""
        dict["parent"] = serialize(entity: parent, metaOnly: true)
        dict["attributes"] = attributes?.compactMap { $0.value()?.dictionary(metaOnly: false) }
        
        return dict
    }
}
