//
//  MSDocument+Convertable.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 28.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSDocument : DictConvertable {
    public  static func from(dict: Dictionary<String, Any>) -> MSEntity<MSDocument>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        guard let group = MSGroup.from(dict: dict.msValue("group")),
            let moment = Date.fromMSDate(dict.value("moment") ?? "") else {
                return MSEntity.meta(meta)
        }
        
        return MSEntity.entity(MSDocument(id: MSID(dict: dict),
                                          meta: meta,
                   info: MSInfo(dict: dict),
                   agent: MSAgent.from(dict: dict.msValue("agent")),
                   contract: MSContract.from(dict: dict.msValue("contract")),
                   sum: Money(minorUnits: dict.value("sum") ?? 0),
                   vatSum: Money(minorUnits: dict.value("vatSum") ?? 0),
                   rate: MSRate.from(dict: dict.msValue("rate")),
                   moment: moment,
                   project: MSProject.from(dict: dict.msValue("project")),
                   organization: MSAgent.from(dict: dict.msValue("organization")),
                   owner: MSEmployee.from(dict: dict.msValue("owner")),
                   group: group,
                   shared: dict.value("shared") ?? false,
                   applicable: dict.value("applicable") ?? false,
                   state: MSState.from(dict: dict.msValue("state")),
                   attributes: dict.msArray("attributes").map { MSAttribute.from(dict: $0) }.flatMap { $0 },
                   originalApplicable: dict.value("applicable") ?? false,
                   agentAccount: MSAccount.from(dict: dict.msValue("agentAccount")),
                   organizationAccount: MSAccount.from(dict: dict.msValue("organizationAccount")),
                   vatIncluded: dict.value("vatIncluded") ?? false,
                   vatEnabled: dict.value("vatEnabled") ?? false,
                   store: MSStore.from(dict: dict.msValue("store")),
                   originalStoreId: MSStore.from(dict: dict.msValue("store"))?.value()?.id.msID,
                   positions: dict.msValue("positions").msArray("rows").map { MSPosition.from(dict: $0) }.flatMap { $0 },
                   stock: [],
                   deliveryPlannedMoment: Date.fromMSDate(dict.value("deliveryPlannedMoment") ?? ""),
                   purchaseOrders: dict.msArray("purchaseOrders").map { MSSimpleDocument.from(dict: $0) }.flatMap { $0 },
                   demands: dict.msArray("demands").map { MSDocument.from(dict: $0) as? MSDemandType }.removeNils(),
                   payments: dict.msArray("payments").map { MSSimpleDocument.from(dict: $0) }.flatMap { $0 },
                   invoicesOut: dict.msArray("invoicesOut").map { MSDocument.from(dict: $0) as? MSInvoiceOutType }.removeNils(),
                   returns: dict.msArray("returns").map { MSSimpleDocument.from(dict: $0) }.flatMap { $0 },
                   factureOut: MSSimpleDocument.from(dict: dict.msValue("factureOut")), 
                   overhead: MSOverhead.from(dict: dict.msValue("overhead")),
                   customerOrder: MSDocument.from(dict: dict.msValue("customerOrder")) as? MSCustomerOrderType,
                   consignee: MSAgent.from(dict: dict.msValue("consignee")), 
                   carrier: MSAgent.from(dict: dict.msValue("carrier")), 
                   transportFacilityNumber: dict.value("transportFacilityNumber"),
                   shippingInstructions: dict.value("shippingInstructions"),
                   cargoName: dict.value("cargoName"),
                   transportFacility: dict.value("transportFacility"),
                   goodPackQuantity: dict.value("goodPackQuantity"), 
                   paymentPlannedMoment: Date.fromMSDate(dict.value("paymentPlannedMoment") ?? ""),
                   purchaseOrder: MSSimpleDocument.from(dict: dict.msValue("purchaseOrder")),
                   incomingNumber: dict.value("incomingNumber"),
                   incomingDate: Date.fromMSDate(dict.value("incomingDate") ?? ""),
                   paymentPurpose: dict.value("paymentPurpose")))
    }
}