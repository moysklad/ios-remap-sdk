//
//  MSDocument+Serialize.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 28.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

func serialize<T:  DictConvertable>(entity: MSEntity<T>?, metaOnly: Bool = true) -> Any {
    return serialize(entity: entity, serializeObject: { $0.dictionary(metaOnly: metaOnly) })
}

func serialize<T:  DictConvertable>(entity: MSEntity<T>?, serializeObject: (T) -> (Any)) -> Any {
    guard let entity = entity else { return NSNull() }

    guard let object = entity.value() else {
        return ["meta": entity.objectMeta().dictionary()]
    }

    return serializeObject(object)
}

func serialize<T:  DictConvertable>(entities: [MSEntity<T>], parent: Metable, metaOnly: Bool = true, objectType: MSObjectType, collectionName: String, serializeObject: ((T) -> (Any))? = nil) -> Any {
    let serialized = entities.map { serialize(entity: $0, serializeObject: serializeObject ?? { $0.dictionary(metaOnly: metaOnly)}) }.filter { $0 is [String:Any] }
    let endIndex = parent.meta.href.range(of: "?")?.lowerBound ?? parent.meta.href.endIndex
    let meta: [String:Any] = ["href":"\(parent.meta.href.prefix(upTo: endIndex))/\(collectionName)",
        "type":objectType.rawValue,
        "mediaType":"application/json",
        "size":serialized.count,
        "limit":100,
        "offset":0]
        
    return ["meta":meta, "rows":serialized]
}

extension MSDocument {
    public func metaAndLinkedSumDictionary() -> [String : Any] {
        var dict = dictionary(metaOnly: true)
        dict["linkedSum"] = linkedSum.minorUnits
        return dict
    }
    
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        dict.merge(id.dictionary())
        
        dict["linkedSum"] = linkedSum.minorUnits
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
        dict["attributes"] = attributes?.compactMap { $0.value() }.map { $0.dictionary(metaOnly: false) }
        if let agentAccount = agentAccount {
            dict["agentAccount"] = serialize(entity: agentAccount, metaOnly: true)
        }
        if let organizationAccount = organizationAccount {
            dict["organizationAccount"] = serialize(entity: organizationAccount, metaOnly: true)
        }
        dict["vatIncluded"] = vatIncluded
        dict["vatEnabled"] = vatEnabled
        dict["store"] = serialize(entity: store, metaOnly: true)
        
        // передаем позиции для всех документов, кроме инвентаризации
        if meta.type != .inventory {
            dict["positions"] = serialize(entities: positions,
                                          parent: self,
                                          metaOnly: false,
                                          objectType: {
                                            switch meta.type {
                                            case MSObjectType.demand:
                                                return MSObjectType.demandposition
                                            case MSObjectType.invoiceout, MSObjectType.invoicein:
                                                return MSObjectType.invoiceposition
                                            case MSObjectType.customerorder:
                                                return MSObjectType.customerorderposition
                                            case MSObjectType.purchaseorder:
                                                return MSObjectType.purchaseorderposition
                                            case MSObjectType.move:
                                                return MSObjectType.moveposition
                                            default:
                                                return MSObjectType.customerorderposition
                                            }}(),
                                          collectionName: "positions")
        }

        dict["deliveryPlannedMoment"] = deliveryPlannedMoment?.toLongDate() ?? NSNull()
        dict["purchaseOrders"] = serialize(entities: purchaseOrders,
                                           parent: self,
                                           metaOnly: false,
                                           objectType: MSObjectType.purchaseorder,
                                           collectionName: "purchaseOrders")
        dict["demands"] = serialize(entities: demands.compactMap { $0 as? MSDocument }.map { MSEntity<MSDocument>.entity($0) },
                                    parent: self,
                                    metaOnly: true,
                                    objectType: MSObjectType.demand,
                                    collectionName: "demands")
        dict["payments"] = serialize(entities: payments,
                                     parent: self,
                                     metaOnly: false,
                                     objectType: MSObjectType.paymentin,
                                     collectionName: "payments")
        dict["invoicesOut"] = serialize(entities: invoicesOut.compactMap { $0 as? MSDocument }.map { MSEntity<MSDocument>.entity($0) },
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
                                       objectType: MSObjectType.customerorder,
                                       collectionName: "operations",
                                       serializeObject: { $0.metaAndLinkedSumDictionary() })
        dict["customerOrders"] = serialize(entities: customerOrders,
                                           parent: self,
                                           objectType: MSObjectType.customerorder, collectionName: "customerOrders")
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
        
        switch meta.type {
        case .paymentin, .supply, .invoicein:
            dict["incomingDate"] = incomingDate?.toLongDate() ?? NSNull()
            dict["incomingNumber"] = incomingNumber ?? ""
        case .move:
            dict["sourceStore"] = serialize(entity: sourceStore, metaOnly: true)
            dict["targetStore"] = serialize(entity: targetStore, metaOnly: true)
            dict["internalOrder"] = serialize(entity: internalOrder, metaOnly: true)
        default:
            break
        }
        
        dict["invoicesIn"] = serialize(entities: invoicesIn,
                                       parent: self,
                                       metaOnly: true,
                                       objectType: MSObjectType.invoicein,
                                       collectionName: "invoicesIn")
        
        dict["supplies"] = serialize(entities: supplies,
                                       parent: self,
                                       metaOnly: true,
                                       objectType: MSObjectType.supply,
                                       collectionName: "supplies")

        return dict
    }
}
