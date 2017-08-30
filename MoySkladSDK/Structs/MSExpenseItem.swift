//
//  MSExpenseItem.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 30.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSExpenseItem: Metable {
    var meta: MSMeta
    
    public init(meta: MSMeta) {
        self.meta = meta
    }
}
