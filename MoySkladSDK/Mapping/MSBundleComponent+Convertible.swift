//
//  MSBundleComponent+Convertible.swift
//  MoySkladSDK
//
//  Created by Anton Efimenko on 05.04.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSBundleComponent : DictConvertable {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSBundleComponent>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        guard let assortment = MSAssortment.from(dict: dict.msValue("assortment")) else {
            return nil
        }

        return MSEntity.entity(MSBundleComponent(meta: meta,
                          id: MSID(dict: dict),
                          accountId: dict.value("accountId") ?? "",
                          quantity: dict.value("quantity") ?? 0,
                          assortment: assortment))
    }
    
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        return dict
    }
}
