//
//  Agent+Serialize.swift
//  MoySkladSDK
//
//  Created by Anton Efimenko on 03.05.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSAgent {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        dict.merge(id.dictionary())
        
        dict["accounts"] = serialize(entities: self.accounts,
                                      parent: self,
                                      metaOnly: false,
                                      objectType: MSObjectType.account,
                                      collectionName: "accounts")
        
        dict["actualAddress"] = self.actualAddress ?? ""
        dict["certificateDate"] = self.certificateDate?.toLongDate() ?? NSNull()
        
        dict["certificateNumber"] = self.certificateNumber ?? ""
        dict["code"] = self.code ?? ""
        dict["companyType"] = self.companyType.rawValue
        dict["email"] = self.email ?? ""
        dict["externalCode"] = self.externalCode ?? ""
        dict["fax"] = self.fax ?? ""
        
        dict["group"] = serialize(entity: group)
        dict["inn"] = self.inn ?? ""
        dict["kpp"] = self.kpp ?? ""
        dict["legalAddress"] = self.legalAddress ?? ""
        dict["legalTitle"] = self.legalTitle ?? ""
        dict["ogrn"] = self.ogrn ?? ""
        dict["ogrnip"] = self.ogrnip ?? ""
        
        dict["okpo"] = self.okpo ?? ""
        dict["owner"] = serialize(entity: owner)
        dict["phone"] = self.phone ?? ""
        //dict["shared"] = self.shared
        dict["tags"] = agentInfo.tags
        
        dict["state"] = serialize(entity: agentInfo.state)
        
        return dict
    }
}
