//
//  CustomerOrder+Convertible.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 26.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation
//import Money

//extension MSCustomerOrder : DictConvertable {
//    public  static func from(dict: Dictionary<String, Any>) -> MSEntity<MSCustomerOrder>? {
//        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
//            return nil
//        }
//        
//        guard let group = MSGroup.from(dict: dict.msValue("group")),
//            let moment = Date.fromMSDate(dict.value("moment") ?? "") else {
//                return MSEntity.meta(meta)
//        }
//        
//        return MSEntity.entity(MSCustomerOrder(meta: meta,
//                        id: MSID(dict: dict),
//                        accountId: dict.value("accountId") ?? "",
//                        info: MSInfo(dict: dict),
//                        code: dict.value("code") ?? "",
//                        externalCode: dict.value("externalCode") ?? "",
//                        archived: dict.value("archived") ?? false,
//                        moment: moment,
//                        applicable: dict.value("applicable") ?? false,
//                        vatIncluded: dict.value("vatIncluded") ?? false,
//                        vatEnabled: dict.value("vatEnabled") ?? false,
//                        sum: Money(minorUnits: dict.value("sum") ?? 0),
//                        rate: MSRate.from(dict: dict.msValue("rate")),
//                        owner: MSEmployee.from(dict: dict.msValue("owner")),
//                        shared: dict.value("shared") ?? false,
//                        group: group,
//                        organization: MSAgent.from(dict: dict.msValue("organization")),
//                        organizationAccount: MSAccount.from(dict: dict.msValue("organizationAccount")),
//                        agent: MSAgent.from(dict: dict.msValue("agent")),
//                        agentAccount: MSAccount.from(dict: dict.msValue("agentAccount")),
//                        store: MSStore.from(dict: dict.msValue("store")),
//                        contract: MSContract.from(dict: dict.msValue("contract")),
//                        state: MSState.from(dict: dict.msValue("state")),
//                        attributes: dict.msArray("attributes").map { MSAttribute.from(dict: $0) }.flatMap { $0 },
//                        vatSum: Money(minorUnits: dict.value("vatSum") ?? 0),
//                        positions: dict.msValue("positions").msArray("rows").map { MSPosition.from(dict: $0) }.flatMap { $0 },
//                        stock: [],
//                        reservedSum: Money(minorUnits: dict.value("reservedSum") ?? 0),
//                        deliveryPlannedMoment: Date.fromMSDate(dict.value("deliveryPlannedMoment") ?? ""),
//                        payedSum: Money(minorUnits: dict.value("payedSum") ?? 0),
//                        shippedSum: Money(minorUnits: dict.value("shippedSum") ?? 0),
//                        invoicedSum: Money(minorUnits: dict.value("invoicedSum") ?? 0),
//                        project: MSProject.from(dict: dict.msValue("project")),
//                        purchaseOrders: dict.msArray("purchaseOrders").map { MSSimpleDocument.from(dict: $0) }.flatMap { $0 },
//                        demands: dict.msArray("demands").map { MSDemand.from(dict: $0) }.flatMap { $0 },
//                        payments: dict.msArray("payments").map { MSSimpleDocument.from(dict: $0) }.flatMap { $0 },
//                        invoicesOut: dict.msArray("invoicesOut").map { MSInvoice.from(dict: $0) }.flatMap { $0 },
//                        originalStoreId: MSStore.from(dict: dict.msValue("store"))?.value()?.id.msID,
//                        originalApplicable: dict.value("applicable") ?? false))
//    }
//    
//    public func dictionary() -> Dictionary<String, Any> {
//        return [String: Any]()
//    }
//}
