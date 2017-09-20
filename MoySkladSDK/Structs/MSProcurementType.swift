//
//  MSProcurementType.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 20.09.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public protocol MSProcurementType: MSGeneralDocument {
    var invoicesIn: [MSEntity<MSDocument>] { get set }
}

public protocol MSSupplyType: MSProcurementType {}
