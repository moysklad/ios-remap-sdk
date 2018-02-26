//
//  Currency.swift
//  MoyskladNew
//
//  Created by Kostya on 19/10/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

/**
 Represents Currency.
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#валюта)
*/
public class MSCurrency : Metable {
	public let meta : MSMeta
	public let name: String
	public let rate: Double
	public let code: String?
	public let isoCode: String?
    public let isDefault: Bool
    
    public init(meta : MSMeta,
    name: String,
    rate: Double,
    code: String?,
    isoCode: String?,
    isDefault: Bool) {
        self.meta = meta
        self.name = name
        self.rate = rate
        self.code = code
        self.isoCode = isoCode
        self.isDefault = isDefault
    }
}

public struct MSRate {
	public let currency: MSEntity<MSCurrency>
	public let value: Double?
    
    public init(currency: MSEntity<MSCurrency>,
                value: Double?) {
        self.currency = currency
        self.value = value
    }
}
