//
//  MSCountry+Convertible.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 20.09.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSCountry: DictConvertable {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        if meta.href.count > 0 {
            dict["meta"] = meta.dictionary()
        }
        
        guard !metaOnly else { return dict }
        
        if meta.href.count > 0 {
            dict.merge(id.dictionary())
        }
        
        dict["name"] = info.name
        dict["description"] = info.description
        dict["code"] = code ?? ""
        dict["externalCode"] = externalCode ?? ""

        return dict
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSCountry>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        return MSEntity.entity(MSCountry(meta: meta,
                                         id: MSID(dict: dict),
                                         info: MSInfo(dict: dict),
                                         code: dict.value("code"),
                                         externalCode: dict.value("externalCode")))
    }
}
