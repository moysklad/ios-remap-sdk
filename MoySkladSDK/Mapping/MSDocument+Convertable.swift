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
        
        var purchaseOrders = dict.msArray("purchaseOrders").map { MSDocument.from(dict: $0) }.compactMap { $0 }
        if let purchaseOrder = MSDocument.from(dict: dict.msValue("purchaseOrder")) {
            purchaseOrders.append(purchaseOrder)
        }
		
		// у инвентаризации нет поля applicable
		// поэтому ставим его в true по умолчанию, что бы он не считался черновиком
		let defaultApplicable = meta.type == .inventory
        
        return MSEntity.entity(MSDocument(id: MSID(dict: dict),
                                          meta: meta,
                   info: MSInfo(dict: dict),
                   agent: MSAgent.from(dict: dict.msValue("agent")),
                   contract: MSContract.from(dict: dict.msValue("contract")),
                   sum: ((dict["sum"] as? NSNumber)?.doubleValue ?? 0.0).toMoney(),
                   vatSum: (dict.value("vatSum") ?? 0.0).toMoney(),
                   payedSum: (dict.value("payedSum") ?? 0.0).toMoney(),
                   rate: MSRate.from(dict: dict.msValue("rate")),
                   moment: moment,
                   project: MSProject.from(dict: dict.msValue("project")),
                   organization: MSAgent.from(dict: dict.msValue("organization")),
                   owner: MSEmployee.from(dict: dict.msValue("owner")),
                   group: group,
                   shared: dict.value("shared") ?? false,
                   applicable: dict.value("applicable") ?? defaultApplicable,
                   state: MSState.from(dict: dict.msValue("state")),
                   attributes: dict.msArray("attributes").map { MSAttribute.from(dict: $0) }.compactMap { $0 },
                   originalApplicable: dict.value("applicable") ?? defaultApplicable,
                   agentAccount: MSAccount.from(dict: dict.msValue("agentAccount")),
                   organizationAccount: MSAccount.from(dict: dict.msValue("organizationAccount")),
                   vatIncluded: dict.value("vatIncluded") ?? false,
                   vatEnabled: dict.value("vatEnabled") ?? false,
                   store: MSStore.from(dict: dict.msValue("store")),
                   originalStoreId: MSStore.from(dict: dict.msValue("store"))?.value()?.id.msID,
                   positions: dict.msValue("positions").msArray("rows").map { MSPosition.from(dict: $0) }.compactMap { $0 },
                   totalPositionsCount: dict.msValue("positions").msValue("meta").value("size") ?? 0,
                   stock: [],
                   deliveryPlannedMoment: Date.fromMSDate(dict.value("deliveryPlannedMoment") ?? ""),
                   purchaseOrders: purchaseOrders,
                   demands: dict.msArray("demands").map { MSDocument.from(dict: $0)?.value() }.removeNils(),
                   payments: dict.msArray("payments").map { MSDocument.from(dict: $0) }.compactMap { $0 },
                   invoicesOut: dict.msArray("invoicesOut").map { MSDocument.from(dict: $0)?.value() }.removeNils(),
                   returns: dict.msArray("returns").map { MSDocument.from(dict: $0) }.compactMap { $0 },
                   factureOut: MSDocument.from(dict: dict.msValue("factureOut")),
                   overhead: MSOverhead.from(dict: dict.msValue("overhead")),
                   customerOrder: MSDocument.from(dict: dict.msValue("customerOrder"))?.value(),
                   consignee: MSAgent.from(dict: dict.msValue("consignee")), 
                   carrier: MSAgent.from(dict: dict.msValue("carrier")), 
                   transportFacilityNumber: dict.value("transportFacilityNumber"),
                   shippingInstructions: dict.value("shippingInstructions"),
                   cargoName: dict.value("cargoName"),
                   transportFacility: dict.value("transportFacility"),
                   goodPackQuantity: dict.value("goodPackQuantity"), 
                   paymentPlannedMoment: Date.fromMSDate(dict.value("paymentPlannedMoment") ?? ""),
                   purchaseOrder: MSDocument.from(dict: dict.msValue("purchaseOrder")),
                   incomingNumber: dict.value("incomingNumber"),
                   incomingDate: Date.fromMSDate(dict.value("incomingDate") ?? ""),
                   paymentPurpose: dict.value("paymentPurpose"),
                   factureIn: MSDocument.from(dict: dict.msValue("factureIn")),
                   expenseItem: MSExpenseItem.from(dict: dict.value("expenseItem") ?? ["": ""]),
                   operations: dict.msArray("operations").map { MSDocument.from(dict: $0) }.compactMap { $0 },
                   linkedSum: (dict.value("linkedSum") ?? 0.0).toMoney(),
                   stateContractId: dict.value("stateContractId"),
                   invoicesIn: dict.msArray("invoicesIn").map { MSDocument.from(dict: $0) }.compactMap { $0 },
                   proceedsNoCash: (dict.value("proceedsNoCash") ?? 0.0).toMoney(),
                   proceedsCash: (dict.value("proceedsCash") ?? 0.0).toMoney(),
                   receivedNoCash: (dict.value("receivedNoCash") ?? 0.0).toMoney(),
                   receivedCash: (dict.value("receivedCash") ?? 0.0).toMoney(),
                   customerOrders: dict.msArray("customerOrders").map { MSDocument.from(dict: $0) }.compactMap { $0 },
                   supplies: dict.msArray("supplies").compactMap { MSDocument.from(dict: $0) },
                   commitentSum: (dict.value("commitentSum") ?? 0.0).toMoney(),
                   sourceStore: MSStore.from(dict: dict.msValue("sourceStore")),
                   targetStore: MSStore.from(dict: dict.msValue("targetStore")),
                   internalOrder: MSDocument.from(dict: dict.msValue("internalOrder")),
                   targetStock: [],
				   enters: dict.msArray("enters").compactMap { MSDocument.from(dict: $0) },
				   losses: dict.msArray("losses").compactMap { MSDocument.from(dict: $0) },
                   positionsManager: nil))
    }
}
