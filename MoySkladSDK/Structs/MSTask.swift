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
    public var info: MSInfo
    public var author: MSEntity<MSEmployee>?
    public var assignee: MSEntity<MSEmployee>?
    public var agent: MSEntity<MSAgent>?
    public var dueToDate: Date?
    public var done: Bool
    
    public init(meta: MSMeta,
         id: MSID,
         info: MSInfo,
         author: MSEntity<MSEmployee>?,
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
    
    public func copy() -> MSTask {
        return MSTask(meta: meta,
                      id: id,
                      info: info,
                      author: author,
                      assignee: assignee,
                      agent: agent,
                      dueToDate: dueToDate,
                      done: done)
    }
    
    public func copyTask() -> MSTask {
        return copy()
    }
}
