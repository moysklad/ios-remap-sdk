//
//  CustomerOrder+Serialize.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 19.01.17.
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

extension MSCustomerOrder {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }

        dict.merge(info.dictionary())
        dict.merge(id.dictionary())
        
        dict["externalCode"] = externalCode
        dict["moment"] = moment.toLongDate()
        dict["applicable"] = applicable
        dict["accountId"] = accountId
        
        dict["vatIncluded"] = vatIncluded
        dict["vatEnabled"] = vatEnabled
        dict["rate"] = rate?.dictionary(metaOnly: true) ?? NSNull()
        dict["shared"] = shared
        dict["owner"] = serialize(entity: owner, metaOnly: true)
        dict["group"] = serialize(entity: group, metaOnly: true)
        
        dict["organization"] = serialize(entity: organization, metaOnly: true)
        dict["agent"] = serialize(entity: agent, metaOnly: true)
        dict["store"] = serialize(entity: store, metaOnly: true)
        dict["contract"] = serialize(entity: contract, metaOnly: true)
        dict["state"] = serialize(entity: state, metaOnly: true)
        
        if let organizationAccount = organizationAccount {
            dict["organizationAccount"] = serialize(entity: organizationAccount, metaOnly: true)
        }
        
        if let agentAccount = agentAccount {
            dict["agentAccount"] = serialize(entity: agentAccount, metaOnly: true)
        }
        
        dict["vatSum"] = vatSum.minorUnits
        dict["positions"] = serialize(entities: positions,
                                      parent: self, 
                                      metaOnly: false, 
                                      objectType: MSObjectType.customerorderposition, 
                                      collectionName: "positions")
        
        //dict["sum"] = sum.minorUnits
        //dict["reservedSum"] = reservedSum.minorUnits
        dict["deliveryPlannedMoment"] = deliveryPlannedMoment?.toLongDate() ?? NSNull()
        //dict["payedSum"] = payedSum.minorUnits
        //dict["shippedSum"] = shippedSum.minorUnits
        //dict["invoicedSum"] = invoicedSum.minorUnits
        dict["project"] = serialize(entity: project, metaOnly: true)

        dict["attributes"] = attributes?.flatMap { $0.value() }.map { $0.dictionary(metaOnly: false) }
        
        return dict
    }
}
