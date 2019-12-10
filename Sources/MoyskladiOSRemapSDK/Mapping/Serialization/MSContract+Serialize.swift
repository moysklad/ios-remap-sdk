//
//  MSContract+Serialize.swift
//  MoyskladiOSRemapSDK
//
//  Created by Антон Ефименко on 21.09.2018.
//  Copyright © 2018 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSContract {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        if meta.href.count > 0 {
            dict["meta"] = meta.dictionary()
        }
        
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        
        dict["owner"] = serialize(entity: owner, metaOnly: true)
        dict["shared"] = shared
        dict["group"] = serialize(entity: group, metaOnly: true)
        dict["code"] = code
        dict["externalCode"] = externalCode ?? ""
        dict["archived"] = archived
        dict["ownAgent"] = serialize(entity: ownAgent, metaOnly: true)
        dict["agent"] = serialize(entity: agent, metaOnly: true)

        dict["state"] = serialize(entity: state, metaOnly: true)
        dict["rate"] = rate?.dictionary(metaOnly: true) ?? NSNull()
        dict["moment"] = moment?.toLongDate()
        dict["attributes"] = attributes?.compactMap { $0.value()?.dictionary(metaOnly: false) }
        
        if let agentAccount = agentAccount {
            dict["agentAccount"] = serialize(entity: agentAccount, metaOnly: true)
        }
        if let organizationAccount = organizationAccount {
            dict["organizationAccount"] = serialize(entity: organizationAccount, metaOnly: true)
        }
        
        dict["rewardPercent"] = rewardPercent
        dict["rewardType"] = rewardType?.rawValue
        dict["contractType"] = contractType?.rawValue
        dict["sum"] = sum.minorUnits
        
        return dict
    }
}
