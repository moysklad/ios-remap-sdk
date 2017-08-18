//
//  MSTask.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 18.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSTask: Metable {
    public let meta: MSMeta
    public let id: MSID
    public let info: MSInfo
    public let author: MSEntity<MSEmployee>
    public let assignee: MSEntity<MSEmployee>?
    public let agent: MSEntity<MSAgent>?
    public let dueToDate: Date?
    public let done: Bool
    
    init(meta: MSMeta,
         id: MSID,
         info: MSInfo,
         author: MSEntity<MSEmployee>,
         assignee: MSEntity<MSEmployee>?,
         agent: MSEntity<MSAgent>?,
         dueToDate: Date?,
         done: Bool) {
        self.meta = meta
        self.id = id
        self.info = info
        self.author = author
        self.assignee = assignee
        self.agent = agent
        self.dueToDate = dueToDate
        self.done = done
    }
}
