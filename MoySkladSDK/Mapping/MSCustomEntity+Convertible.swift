//
//  MSCustomEntity+Convertible.swift
//  MoySkladSDK
//
//  Created by Anton Efimenko on 09.02.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSCustomEntity : DictConvertable {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSCustomEntity>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        return MSEntity.entity(MSCustomEntity(meta: meta,
                              id: dict.value("id") ?? "",
                              name: dict.value("name") ?? "",
                              code: dict.value("code"),
                              externalCode: dict.value("externalCode")))
    }
    
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        dict["id"] = id
        dict["name"] = name
        dict["code"] = code ?? NSNull()
        dict["externalCode"] = externalCode ?? NSNull()
        
        return dict
    }
}
