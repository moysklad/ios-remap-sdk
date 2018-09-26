//
//  MSProject+Serialize.swift
//  MoyskladiOSRemapSDK
//
//  Created by Антон Ефименко on 21.09.2018.
//  Copyright © 2018 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSProject {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        
        dict["owner"] = serialize(entity: owner, metaOnly: true)
        dict["shared"] = shared
        dict["group"] = serialize(entity: group, metaOnly: true)
        dict["name"] = info.name
        dict["description"] = info.description
        dict["code"] = code
        dict["externalCode"] = externalCode ?? ""
        dict["archived"] = archived
        dict["attributes"] = attributes?.compactMap { $0.value()?.dictionary(metaOnly: false) }
        
        return dict
    }
}
