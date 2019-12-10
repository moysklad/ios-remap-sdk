//
//  Project+Convertible.swift
//  MoyskladNew
//
//  Created by Kostya on 27/10/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSProject : DictConvertable {    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSProject>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        guard let name: String = dict.value("name"), name.count > 0,
            let group = MSGroup.from(dict: dict.msValue("group")) else {
                return MSEntity.meta(meta)
        }
        
        
        return MSEntity.entity(MSProject(meta: meta,
                                       id: MSID(dict: dict),
                                       info: MSInfo(dict: dict),
                                       accountId: dict.value("accountId") ?? "",
                                       owner: MSEmployee.from(dict: dict.msValue("owner")),
                                       shared: dict.value("shared") ?? false,
                                       group: group,
                                       code: dict.value("code"),
                                       externalCode: dict.value("externalCode"),
                                       archived: dict.value("archived") ?? false,
                                       attributes: dict.msArray("attributes").compactMap { MSAttribute.from(dict: $0) }))
    }
}
