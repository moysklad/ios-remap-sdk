//
//  MSNotification+Convertable.swift
//  MoyskladiOSRemapSDK
//
//  Created by Zhdanova Tatyana on 21/12/2018.
//  Copyright © 2018 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSNotification : DictConvertable {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        dict["readed"] = readed
        dict["notificationType"] = notificationType
        
        return dict
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSNotification>? {
        guard let meta = MSMeta.from(dict: dict["meta"] as? [String: Any] ?? [:], parent: dict) else {
            return nil
        }
        
        guard let readed: Bool = dict.value("readed") else {
            return MSEntity.meta(meta)
        }
        
        guard let notificationType: String = dict.value("notificationType"), notificationType.count > 0 else {
            return MSEntity.meta(meta)
        }
        
        return MSEntity.entity(MSNotification(meta: meta, readed: readed, notificationType: notificationType))
    }
}
