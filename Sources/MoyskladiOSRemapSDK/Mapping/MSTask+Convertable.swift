//
//  MSTask+Convertable.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 18.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSTask: DictConvertable {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSTask>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        return MSEntity.entity(MSTask(meta: meta,
               id: MSID(dict: dict),
               info: MSInfo(dict: dict),
               author: MSEmployee.from(dict: dict.msValue("author")),
               assignee: MSEmployee.from(dict: dict.msValue("assignee")),
               agent: MSAgent.from(dict: dict.msValue("agent")),
               dueToDate: Date.fromMSDate(dict.value("dueToDate") ?? ""),
               done: dict.value("done") ?? false))
    }
}
