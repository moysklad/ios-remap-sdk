//
//  MSProject+Serialize.swift
//  MoyskladiOSRemapSDK
//
//  Created by Антон Ефименко on 21.09.2018.
//  Copyright © 2018 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSProject {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        // тут должны быть остальные поля объекта, если они понадобятся
        
        return dict
    }
}
