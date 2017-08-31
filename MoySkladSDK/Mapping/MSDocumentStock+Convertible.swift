//
//  MSDocumentStock+Convertible.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 31.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSDocumentStock: DictConvertable {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        // тут должны быть остальные поля объекта, если они понадобятся
        
        return dict
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSDocumentStock>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {  return nil }
        
        return MSEntity.entity(MSDocumentStock(meta: meta,
                                               stock: dict.value("stock") ?? 0,
                                               inTransit: dict.value("inTransit") ?? 0,
                                               reserve: dict.value("reserve") ?? 0,
                                               quantity: dict.value("quantity") ?? 0,
                                               name: dict.value("name") ?? "",
                                               cost: Money(minorUnits: dict.value("cost") ?? 0)))
    }
}
