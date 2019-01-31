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
        
        dict["accountId"] = accountId
        dict["readed"] = readed
        dict["updated"] = updated
        dict["notificationType"] = notificationType
        dict["notification"] = notification
        
        return dict
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSNotification>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }
        let data = (dict["notification"] as! String).data(using: .utf8) ?? Data()
        let json = JSONType.fromRaw(data)
        return MSEntity.entity(MSNotification(id: dict.value("id"), meta: meta, accountId: dict.value("accountId"), readed: dict.value("readed"), updated: dict.value("updated"), notificationType: dict.value("notificationType"), notification: MSNotificationContent.from(dict: json?.toDictionary() ?? [:])))
    }
}
