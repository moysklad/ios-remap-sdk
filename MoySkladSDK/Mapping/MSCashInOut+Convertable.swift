//
//  MSCashInOut+Convertable.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 25.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSCashInOut: DictConvertable {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSCashInOut>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }
        
        guard let group = MSGroup.from(dict: dict.msValue("group")),
            let moment = Date.fromMSDate(dict.value("moment") ?? "") else {
                return MSEntity.meta(meta)
        }
        
        return MSEntity.entity(MSCashInOut(meta: meta,
                    id: MSID(dict: dict),
                    accountId: dict.value("accountId") ?? "",
                    info: MSInfo(dict: dict),
                    externalCode: dict.value("externalCode") ?? "",
                    moment: moment,
                    applicable: dict.value("applicable") ?? false,
                    vatIncluded: dict.value("vatIncluded") ?? false,
                    vatEnabled: dict.value("vatEnabled") ?? false,
                    sum: Money(minorUnits: dict.value("sum") ?? 0),
                    rate: MSRate.from(dict: dict.msValue("rate")),
                    owner: MSEmployee.from(dict: dict.msValue("owner")),
                    shared: dict.value("shared") ?? false,
                    group: group,
                    organization: MSAgent.from(dict: dict.msValue("organization")),
                    agent: MSAgent.from(dict: dict.msValue("agent")),
                    contract: MSContract.from(dict: dict.msValue("contract")),
                    state: MSState.from(dict: dict.msValue("state")),
                    attributes: dict.msArray("attributes").map { MSAttribute.from(dict: $0) }.flatMap { $0 },
                    vatSum: Money(minorUnits: dict.value("vatSum") ?? 0),
                    project: MSProject.from(dict: dict.msValue("project")),
                    cashInOutInfo: MSCashInOutInfo.from(dict: dict),
                    originalApplicable: dict.value("applicable") ?? false,
                    paymentPurpose: dict.value("paymentPurpose")))
    }
}

extension MSCashInOutInfo {
    public func dictionary() -> Dictionary<String, Any> {
        return [String:Any]()
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSCashInOutInfo {
        return MSCashInOutInfo(incomingDate: dict.value("incomingDate"), incomingNumber: dict.value("incomingNumber"))
    }
}
