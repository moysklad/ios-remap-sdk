//
//  MSBundleComponent.swift
//  MoySkladSDK
//
//  Created by Anton Efimenko on 05.04.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public final class MSBundleComponent : Metable {
    public let meta: MSMeta
    public let id: MSID
    public let accountId: String
    public let quantity: Double
    public let assortment: MSEntity<MSAssortment>
    
    public init(meta: MSMeta, id: MSID, accountId: String, quantity: Double, assortment: MSEntity<MSAssortment>) {
        self.meta = meta
        self.id = id
        self.accountId = accountId
        self.quantity = quantity
        self.assortment = assortment
    }
}
