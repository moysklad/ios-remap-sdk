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
        
        guard let parentId = meta.href.withoutParameters().components(separatedBy: "/").dropLast().last else {
            return nil
        }
        
        return MSEntity.entity(MSCustomEntity(meta: meta,
                              id: MSID(dict: dict),
                              name: dict.value("name") ?? "",
                              code: dict.value("code"),
                              externalCode: dict.value("externalCode"),
                              description: dict.value("description"),
                              parentId: parentId))
    }
}
