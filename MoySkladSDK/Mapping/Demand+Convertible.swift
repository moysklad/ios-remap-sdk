//
//  Demand+Convertible.swift
//  MoyskladNew
//
//  Created by Kostya on 27/10/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

//import Money
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

extension MSDemand : DictConvertable {
    public func dictionary() -> Dictionary<String, Any> {
        return [String: Any]()
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSDemand>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }

        guard let group = MSGroup.from(dict: dict.msValue("group"))else {
            return MSEntity.meta(meta)
        }
        
        guard let moment = Date.fromMSDate(dict.value("moment") ?? "") else {
            return MSEntity.meta(meta)
        }
        
        return MSEntity.entity(MSDemand(meta: meta,
                                        id: MSID(dict: dict),
                                        accountId: dict.value("accountId") ?? "",
                                        info: MSInfo(dict: dict),
                                        code: dict.value("code"),
                                        externalCode: dict.value("externalCode"),
                                        archived: dict.value("archived") ?? false,
                                        moment: moment,
                                        applicable: dict.value("applicable") ?? false,
                                        vatIncluded: dict.value("vatIncluded") ?? false,
                                        vatEnabled: dict.value("vatIncluded") ?? false,
                                        sum: Money(minorUnits: dict.value("sum") ?? 0),
                                        rate: MSRate.from(dict: dict.msValue("rate")),
                                        owner: MSEmployee.from(dict: dict.msValue("owner")),
                                        shared: dict.value("shared") ?? false,
                                        group: group,
                                        organization: MSAgent.from(dict: dict.msValue("organization")),
                                        agent: MSAgent.from(dict: dict.msValue("agent")),
                                        store: MSStore.from(dict: dict.msValue("store")),
                                        contract: MSContract.from(dict: dict.msValue("contract")),
                                        project: MSProject.from(dict: dict.msValue("project")),
                                        state: MSState.from(dict: dict.msValue("state")),
                                        organizationAccount: MSAccount.from(dict: dict.msValue("organizationAccount")),
                                        agentAccount: MSAccount.from(dict: dict.msValue("agentAccount")),
                                        attributes: dict.msArray("attributes").map { MSAttribute.from(dict: $0) }.flatMap { $0 },
                                        documents: nil,
                                        vatSum: Money(minorUnits: dict.value("vatSum") ?? 0),
                                        positions: dict.msValue("positions").msArray("rows").map { MSPosition.from(dict: $0) }.flatMap { $0 },
                                        stock: [],
                                        overhead: MSOverhead.from(dict: dict.msValue("overhead")),
                                        payedSum: Money(minorUnits: dict.value("payedSum") ?? 0),
                                        consignee: MSAgent.from(dict: dict.msValue("consignee")),
                                        carrier: MSAgent.from(dict: dict.msValue("carrier")),
                                        transportFacilityNumber: dict.value("transportFacilityNumber"),
                                        shippingInstructions: dict.value("shippingInstructions"),
                                        cargoName: dict.value("cargoName"),
                                        transportFacility: dict.value("transportFacility"),
                                        goodPackQuantity: dict.value("goodPackQuantity"),
                                        invoicesOut : dict.msArray("invoicesOut").map { MSInvoice.from(dict: $0) }.flatMap { $0 },
                                        payments : dict.msArray("payments").map { MSSimpleDocument.from(dict: $0) }.flatMap { $0 },
                                        returns: dict.msArray("returns").map { MSSimpleDocument.from(dict: $0) }.flatMap { $0 },
                                        factureOut : MSSimpleDocument.from(dict: dict.msValue("factureOut")),
                                        customerOrder: MSCustomerOrder.from(dict: dict.msValue("customerOrder")),
                                        originalStoreId: MSStore.from(dict: dict.msValue("store"))?.value()?.id.msID,
                                        originalApplicable: dict.value("applicable") ?? false))
    }
}
