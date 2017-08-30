//
//  MSExpenseItem+Convertible.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 30.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSExpenseItem: DictConvertable {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSExpenseItem>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }
        
        return MSEntity.entity(MSExpenseItem(meta: meta))
    }
}
