//
//  MSRetailStore+Convertable.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 02.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSRetailStore: DictConvertable {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSRetailStore>? {
        let retailstore = dict.msValue("retailstore")
        
        guard let meta = MSMeta.from(dict: retailstore.msValue("meta"), parent: dict) else { return nil }
        
        return MSEntity.entity(MSRetailStore(meta: meta,
                                             info: MSInfo(dict: retailstore),
                                             retailShift: MSRetailShift.from(dict: dict.msValue("retailshift")),
                                             proceed: (dict.value("proceed") ?? 0.0).toMoney(),
                                             balance: (dict.value("balance") ?? 0.0).toMoney(),
                                             environment: MSRetailStoreEnvironment.from(dict: dict.msValue("environment")),
                                             state: MSRetailStoreState.from(dict: dict.msValue("state"))))
    }
    
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        return [:]
    }
}

extension MSRetailShift: DictConvertable {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSRetailShift>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict), let created = Date.fromMSDate(dict.value("created") ?? ""), let state = MSRetailShiftStateType(rawValue: dict.value("state") ?? "") else { return nil }
        
        return MSEntity.entity(MSRetailShift(meta: meta,
                                             created: created,
                                             closeDate: Date.fromMSDate(dict.value("closeDate") ?? ""),
                                             state: state))
    }
    
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        return [:]
    }
}
