//
//  MSRetailShift.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 02.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public enum MSRetailShiftStateType: String {
    case close
    case open
}

public class MSReportRetailShift: Metable {
    public let meta: MSMeta
    public let created: Date
    public let closeDate: Date?
    public let state: MSRetailShiftStateType
    
    init(meta: MSMeta, created: Date, closeDate: Date?, state: MSRetailShiftStateType) {
        self.meta = meta
        self.created = created
        self.closeDate = closeDate
        self.state = state
    }
}

public class MSRetailShift: Metable {
    public let meta: MSMeta
    public let moment: Date
    public let closeDate: Date?
    public let owner: MSEntity<MSEmployee>?
    public var isOpen: Bool { return closeDate == nil }
    
    init(meta: MSMeta, moment: Date, closeDate: Date?, owner: MSEntity<MSEmployee>?) {
        self.meta = meta
        self.moment = moment
        self.closeDate = closeDate
        self.owner = owner
    }
}
