//
//  MSDocument+Serialize.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 28.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

func serialize<T:  DictConvertable>(entity: MSEntity<T>?, metaOnly: Bool = true) -> Any {
    guard let entity = entity else { return NSNull() }
    
    guard let object = entity.value() else {
        return ["meta": entity.objectMeta().dictionary()]
    }
    
    return object.dictionary(metaOnly: metaOnly)
}

func serialize<T:  DictConvertable>(entities: [MSEntity<T>], parent: Metable, metaOnly: Bool = true, objectType: MSObjectType, collectionName: String) -> Any {
    let serialized = entities.map { serialize(entity: $0, metaOnly: metaOnly) }.filter { o in
        if o is [String:Any] {
            return true
        }
        return false
    }
    let endIndex = parent.meta.href.range(of: "?")?.lowerBound ?? parent.meta.href.endIndex
    let meta: [String:Any] = ["href":"\(parent.meta.href.substring(to: endIndex))/\(collectionName)",
        "type":objectType.rawValue,
        "mediaType":"application/json",
        "size":serialized.count,
        "limit":100,
        "offset":0]
    
    return ["meta":meta, "rows":serialized]
}

extension MSDocument {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        dict["meta"] = meta.dictionary()
        dict["linkedSum"] = linkedSum.minorUnits
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        dict.merge(id.dictionary())
        
        dict["sum"] = sum.minorUnits
        dict["agent"] = serialize(entity: agent, metaOnly: true)
        dict["contract"] = serialize(entity: contract, metaOnly: true)
        dict["vatSum"] = vatSum.minorUnits
        dict["payedSum"] = payedSum.minorUnits
        dict["rate"] = rate?.dictionary(metaOnly: true) ?? NSNull()
        dict["moment"] = moment.toLongDate()
        dict["project"] = serialize(entity: project, metaOnly: true)
        dict["organization"] = serialize(entity: organization, metaOnly: true)
        dict["owner"] = serialize(entity: owner, metaOnly: true)
        dict["group"] = serialize(entity: group, metaOnly: true)
        dict["shared"] = shared
        dict["applicable"] = applicable
        dict["state"] = serialize(entity: state, metaOnly: true)
        dict["attributes"] = attributes?.flatMap { $0.value() }.map { $0.dictionary(metaOnly: false) }
        if let agentAccount = agentAccount {
            dict["agentAccount"] = serialize(entity: agentAccount, metaOnly: true)
        }
        if let organizationAccount = organizationAccount {
            dict["organizationAccount"] = serialize(entity: organizationAccount, metaOnly: true)
        }
        dict["vatIncluded"] = vatIncluded
        dict["vatEnabled"] = vatEnabled
        dict["store"] = serialize(entity: store, metaOnly: true)
        dict["positions"] = serialize(entities: positions,
                                      parent: self,
                                      metaOnly: false,
                                      objectType: {
                                        switch meta.type {
                                        case MSObjectType.demand:
                                            return MSObjectType.demandposition
                                        case MSObjectType.invoiceout:
                                            return MSObjectType.invoiceposition
                                        case MSObjectType.customerorder:
                                            return MSObjectType.customerorderposition
                                        default:
                                            return MSObjectType.customerorderposition
                                        }}(),
                                      collectionName: "positions")

        dict["deliveryPlannedMoment"] = deliveryPlannedMoment?.toLongDate() ?? NSNull()
        dict["purchaseOrders"] = serialize(entities: purchaseOrders,
                                           parent: self,
                                           metaOnly: false,
                                           objectType: MSObjectType.purchaseorder,
                                           collectionName: "purchaseOrders")
        dict["demands"] = serialize(entities: demands.flatMap { $0 as? MSDocument }.map { MSEntity<MSDocument>.entity($0) },
                                    parent: self,
                                    metaOnly: true,
                                    objectType: MSObjectType.demand,
                                    collectionName: "demands")
        dict["payments"] = serialize(entities: payments,
                                     parent: self,
                                     metaOnly: false,
                                     objectType: MSObjectType.paymentin,
                                     collectionName: "payments")
        dict["invoicesOut"] = serialize(entities: invoicesOut.flatMap { $0 as? MSDocument }.map { MSEntity<MSDocument>.entity($0) },
                                        parent: self,
                                        metaOnly: true,
                                        objectType: MSObjectType.invoiceout,
                                        collectionName: "invoicesOut")
        dict["returns"] = serialize(entities: returns,
                                    parent: self,
                                    metaOnly: false,
                                    objectType: MSObjectType.salesreturn,
                                    collectionName: "returns")
        dict["operations"] = serialize(entities: operations,
                                       parent: self,
                                       objectType: MSObjectType.customerorder, collectionName: "operations")
        if let factureOut = factureOut {
            dict["factureOut"] = serialize(entity: factureOut, metaOnly: true)
        }
        if let factureIn = factureIn {
            dict["factureIn"] = serialize(entity: factureIn, metaOnly: true)
        }
        if let overhead = overhead {
            dict["overhead"] = overhead.dictionary()
        }
        if let customerOrder = customerOrder as? MSDocument {
            dict["customerOrder"] = serialize(entity: MSEntity.entity(customerOrder), metaOnly: true)
        }
        dict["consignee"] = serialize(entity: consignee, metaOnly: true)
        dict["carrier"] = serialize(entity: carrier, metaOnly: true)
        dict["transportFacilityNumber"] = transportFacilityNumber ?? ""
        dict["shippingInstructions"] = shippingInstructions ?? ""
        dict["cargoName"] = cargoName ?? ""
        dict["transportFacility"] = transportFacility ?? ""
        dict["goodPackQuantity"] = goodPackQuantity ?? NSNull()
        dict["paymentPlannedMoment"] = paymentPlannedMoment?.toLongDate() ?? NSNull()
        dict["purchaseOrder"] = serialize(entity: purchaseOrder, metaOnly: true)
        
        dict["paymentPurpose"] = paymentPurpose ?? ""
        dict["stateContractId"] = stateContractId ?? ""
        dict["expenseItem"] = serialize(entity: expenseItem, metaOnly: true)
        
        // сервер ломается, если отправить incomingDate и incomingNumber документу, у которого такого поля нет
        // https://lognex.atlassian.net/browse/MC-22182
        if meta.type == .paymentin {
            dict["incomingDate"] = incomingDate?.toLongDate() ?? NSNull()
            dict["incomingNumber"] = incomingNumber ?? ""
        }
        
        return dict
    }
}
