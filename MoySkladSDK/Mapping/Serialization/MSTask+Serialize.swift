//
//  MSTask+Serialize.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 18.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSTask {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        dict.merge(id.dictionary())
        
        dict["done"] = done
        dict["dueToDate"] = dueToDate?.toLongDate() ?? NSNull()
        dict["author"] = serialize(entity: author)
        dict["assignee"] = serialize(entity: assignee)
        dict["agent"] = serialize(entity: agent)
        
        return dict
    }
}
