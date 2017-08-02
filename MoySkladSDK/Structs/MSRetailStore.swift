//
//  MSRetailStore.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 02.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSRetailStore: Metable {
    public let meta: MSMeta
    public let info: MSInfo
    public let retailShift: MSEntity<MSRetailShift>?
    public let proceed: Money
    public let balance: Money
    
    init(meta: MSMeta, info: MSInfo, retailShift: MSEntity<MSRetailShift>?, proceed: Money, balance: Money) {
        self.meta = meta
        self.info = info
        self.retailShift = retailShift
        self.proceed = proceed
        self.balance = balance
    }
}
