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
        
        dict.merge(id.dictionary())
        
        return resultDict(dict)
    }
    
    public func dictionaryForCreate() -> Dictionary<String, Any> {
        return resultDict()
    }
    
    private func resultDict(_ dict: Dictionary<String, Any> = [String: Any]()) -> Dictionary<String, Any> {
        var result = dict
        result.merge(info.dictionary())
        result["done"] = done
        result["dueToDate"] = dueToDate?.toLongDate() ?? NSNull()
        result["author"] = serialize(entity: author)
        result["assignee"] = serialize(entity: assignee)
        result["agent"] = serialize(entity: agent)
        return result
    }
}
