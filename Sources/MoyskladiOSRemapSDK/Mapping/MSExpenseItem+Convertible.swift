//
//  MSExpenseItem+Convertible.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 30.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSExpenseItem: DictConvertable {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        // тут должны быть остальные поля объекта, если они понадобятся
        
        return dict
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSExpenseItem>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }
        
        return MSEntity.entity(MSExpenseItem(id: MSID(dict: dict),
                                             meta: meta,
                                             info: MSInfo(dict: dict)))
    }
}
