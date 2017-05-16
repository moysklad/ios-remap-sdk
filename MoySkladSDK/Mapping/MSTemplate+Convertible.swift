//
//  MSEmbeddedTemplate+Convertible.swift
//  MoySkladSDK
//
//  Created by Vladislav on 10.04.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSTemplate : DictConvertable {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        return dict
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSTemplate>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        return MSEntity.entity(MSTemplate(meta: meta,
                                          id: MSID(dict: dict),
                                          name: dict.value("name") ?? ""))
    }
}
