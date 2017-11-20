//
//  MSUOM+Convertable.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 09.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSUOM: DictConvertable {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        if meta.href.count > 0 {
            dict["meta"] = meta.dictionary()
        }
        
        return dict
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSUOM>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }
        
        guard let name: String = dict.value("name"), name.count > 0 else { return MSEntity.meta(meta) }
        
        return MSEntity.entity(MSUOM(meta: meta,
              id: MSID(dict: dict),
              info: MSInfo(dict: dict), 
              code: dict.value("code"),
              externalCode: dict.value("externalCode")
        ))
    }
}
