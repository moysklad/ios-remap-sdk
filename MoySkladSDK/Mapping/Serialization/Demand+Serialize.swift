//
//  Demand+Serialize.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 24.01.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation
//
//extension MSDemand {
//    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
//        var dict = [String: Any]()
//        
//        dict["meta"] = meta.dictionary()
//        
//        guard !metaOnly else { return dict }
//        
//        dict.merge(info.dictionary())
//        dict.merge(id.dictionary())
//        
//        dict["externalCode"] = externalCode ?? ""
//        dict["moment"] = moment.toLongDate()
//        dict["applicable"] = applicable
//        dict["accountId"] = accountId
//        
//        dict["vatIncluded"] = vatIncluded
//        dict["vatEnabled"] = vatEnabled
//        dict["rate"] = rate?.dictionary(metaOnly: true) ?? NSNull()
//        dict["shared"] = shared
//        dict["owner"] = serialize(entity: owner, metaOnly: true)
//        dict["group"] = serialize(entity: group, metaOnly: true)
//        
//        dict["organization"] = serialize(entity: organization, metaOnly: true)
//        dict["agent"] = serialize(entity: agent, metaOnly: true)
//        dict["store"] = serialize(entity: store, metaOnly: true)
//        dict["contract"] = serialize(entity: contract, metaOnly: true)
//        dict["state"] = serialize(entity: state, metaOnly: true)
//        
//        if let organizationAccount = organizationAccount {
//            dict["organizationAccount"] = serialize(entity: organizationAccount, metaOnly: true)
//        }
//        
//        if let agentAccount = agentAccount {
//            dict["agentAccount"] = serialize(entity: agentAccount, metaOnly: true)
//        }
//        
//        dict["vatSum"] = vatSum.minorUnits
//        
//        dict["positions"] = serialize(entities: positions,
//                                      parent: self,
//                                      metaOnly: false,
//                                      objectType: MSObjectType.demandposition,
//                                      collectionName: "positions")
//        
//        dict["invoicesOut"] = serialize(entities: invoicesOut,
//                                    parent: self,
//                                    metaOnly: true,
//                                    objectType: MSObjectType.invoiceout,
//                                    collectionName: "invoicesOut")
//        
//        //dict["sum"] = sum.minorUnits
//        dict["project"] = serialize(entity: project, metaOnly: true)
//        if let overhead = overhead {
//            dict["overhead"] = overhead.dictionary()
//        }
//        dict["consignee"] = serialize(entity: consignee, metaOnly: true)
//        dict["carrier"] = serialize(entity: carrier, metaOnly: true)
//        dict["transportFacilityNumber"] = transportFacilityNumber ?? ""
//        dict["shippingInstructions"] = shippingInstructions  ?? ""
//        dict["customerOrder"] = serialize(entity: customerOrder, metaOnly: true)
//        
//        dict["cargoName"] = cargoName ?? ""
//        dict["transportFacility"] = transportFacility ?? ""
//        dict["goodPackQuantity"] = goodPackQuantity ?? NSNull()
//        
//        dict["attributes"] = attributes?.flatMap { $0.value() }.map { $0.dictionary(metaOnly: false) }
//        
//        return dict
//    }
//}
