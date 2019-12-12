//
//  MSPack.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 18.10.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSPack {
    public let id: MSID
    public var quantity: Double
    public var uom: MSEntity<MSUOM>?
    
    public init(id: MSID,
                quantity: Double,
                uom: MSEntity<MSUOM>?) {
        self.id = id
        self.quantity = quantity
        self.uom = uom
    }
    
    public func copy() -> MSPack {
        return MSPack(id: id, quantity: quantity, uom: uom)
    }
}
