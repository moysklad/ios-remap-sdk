//
//  MSCashInOut+Serialize.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 25.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSCashInOut {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        dict.merge(id.dictionary())
        
        return dict
    }
}
