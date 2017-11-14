//
//  MSOverhead+Convertible.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 31.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSOverhead {
    public static func from(dict: Dictionary<String, Any>) -> MSOverhead? {
        guard let distr = MSOverheadDistribution(rawValue: dict.value("distribution") ?? "") else { return nil }
        
        return MSOverhead(sum: Money(minorUnits: dict.value("sum") ?? 0), distribution: distr)
    }
    
    public func dictionary() -> Dictionary<String, Any> {
        return ["sum": sum.minorUnits, "distribution":distribution.rawValue]
    }
}

extension MSBundleOverhead {
    public static func from(dict: Dictionary<String, Any>) -> MSBundleOverhead? {
        guard let currency = MSCurrency.from(dict: dict.msValue("currency")) else { return nil }
        return MSBundleOverhead(value: Money(minorUnits: dict.value("value") ?? 0), currency: currency)
    }
    
    public func dictionary() -> Dictionary<String, Any> {
        return ["value": value.minorUnits, "currency": serialize(entity: currency)]
    }
}
