//
//  MSInvoice+Convertible.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 31.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation
//import Money

//extension MSInvoice : DictConvertable {
//    public func dictionary() -> Dictionary<String, Any> {
//        return [String:Any]()
//    }
//    
//    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSInvoice>? {
//        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
//            return nil
//        }
//        
//        guard let group = MSGroup.from(dict: dict.msValue("group")),
//            let moment = Date.fromMSDate(dict.value("moment") ?? "") else {
//                return MSEntity.meta(meta)
//        }
//        
//        return MSEntity.entity(MSInvoice(meta: meta,
//                  id: MSID(dict: dict),
//                  accountId: dict.value("accountId") ?? "",
//                  info: MSInfo(dict: dict),
//                  externalCode: dict.value("externalCode") ?? "",
//                  moment: moment,
//                  applicable: dict.value("applicable") ?? false,
//                  vatIncluded: dict.value("vatIncluded") ?? false,
//                  vatEnabled: dict.value("vatEnabled") ?? false,
//                  sum: Money(minorUnits: dict.value("sum") ?? 0),
//                  rate: MSRate.from(dict: dict.msValue("rate")),
//                  owner: MSEmployee.from(dict: dict.msValue("owner")),
//                  shared: dict.value("shared") ?? false,
//                  group: group,
//                  organization: MSAgent.from(dict: dict.msValue("organization")),
//                  agent: MSAgent.from(dict: dict.msValue("agent")),
//                  store: MSStore.from(dict: dict.msValue("store")),
//                  contract: MSContract.from(dict: dict.msValue("contract")),
//                  state: MSState.from(dict: dict.msValue("state")),
//                  organizationAccount: MSAccount.from(dict: dict.msValue("organizationAccount")),
//                  agentAccount: MSAccount.from(dict: dict.msValue("agentAccount")),
//                  attributes: dict.msArray("attributes").map { MSAttribute.from(dict: $0) }.flatMap { $0 },
//                  vatSum: Money(minorUnits: dict.value("vatSum") ?? 0),
//                  positions: dict.msValue("positions").msArray("rows").map { MSPosition.from(dict: $0) }.flatMap { $0 },
//                  stock : [],
//                  paymentPlannedMoment: Date.fromMSDate(dict.value("paymentPlannedMoment") ?? ""),
//                  payedSum: Money(minorUnits: dict.value("payedSum") ?? 0),
//                  shippedSum: Money(minorUnits: dict.value("shippedSum") ?? 0),
//                  project: MSProject.from(dict: dict.msValue("project")),
//                  incomingNumber: dict.value("incomingNumber"),
//                  incomingDate: Date.fromMSDate(dict.value("incomingDate") ?? ""),
//                  invoiceInfo: MSInvoiceInfo.from(dict: dict),
//                  originalStoreId: MSStore.from(dict: dict.msValue("store"))?.value()?.id.msID,
//                  originalApplicable: dict.value("applicable") ?? false))
//    }
//}
//
//extension MSInvoiceInfo {
//    public func dictionary() -> Dictionary<String, Any> {
//        return [String:Any]()
//    }
//    
//    public static func from(dict: Dictionary<String, Any>) -> MSInvoiceInfo {        
//        return MSInvoiceInfo(customerOrder: MSCustomerOrder.from(dict: dict.msValue("customerOrder")),
//                             demands: dict.msArray("demands").map { MSDemand.from(dict: $0) }.flatMap { $0 },
//                             payments: dict.msArray("payments").map { MSSimpleDocument.from(dict: $0) }.flatMap { $0 },
//                             purchaseOrder: MSSimpleDocument.from(dict: dict.msValue("purchaseOrder")),
//                             incomingNumber: dict.value("incomingNumber"),
//                             incomingDate: Date.fromMSDate(dict.value("incomingDate") ?? ""))
//    }
//}
