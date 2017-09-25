//
//  MSRetailShiftType.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 25.09.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public protocol MSRetailShiftType: MSGeneralDocument {
    var proceedsNoCash: Money { get set }
    var proceedsCash: Money { get set }
    var receivedNoCash: Money { get set }
    var receivedCash: Money { get set }
}
