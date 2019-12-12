//
//  MSCustomEntity+Serialize.swift
//  MoyskladiOSRemapSDK
//
//  Created by Антон Ефименко on 05.09.2018.
//  Copyright © 2018 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSCustomEntity {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        if meta.href.count > 0 {
            dict["meta"] = meta.dictionary()
        }
        
        guard !metaOnly else { return dict }
        
        dict.merge(id.dictionary())
        
        dict["name"] = name
        dict["code"] = code ?? ""
        dict["externalCode"] = externalCode ?? ""
        dict["description"] = description ?? ""
        
        return dict
    }
}
