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
        
        if meta.href.characters.count > 0 {
            dict["meta"] = meta.dictionary()
        }
        
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        
        let idDict = id.dictionary()
        if !idDict.isEmpty {
            dict.merge(idDict)
        }
        
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
        
        dict["inn"] = self.inn ?? ""
        dict["kpp"] = self.kpp ?? ""
        dict["legalAddress"] = self.legalAddress ?? ""
        dict["legalTitle"] = self.legalTitle ?? ""
        dict["ogrn"] = self.ogrn ?? ""
        dict["ogrnip"] = self.ogrnip ?? ""
        dict["archived"] = self.archived
        
        dict["okpo"] = self.okpo ?? ""
        if meta.href.characters.count > 0 {
            dict["owner"] = serialize(entity: owner)
            dict["group"] = serialize(entity: group)
        }
        dict["phone"] = self.phone ?? ""
        //dict["shared"] = self.shared
        dict["tags"] = agentInfo.tags
        
        dict["state"] = serialize(entity: agentInfo.state)
        
        if !self.agentInfo.contactpersons.isEmpty {
            dict["contactpersons"] = serialize(entities: self.agentInfo.contactpersons,
                                     parent: self,
                                     metaOnly: false,
                                     objectType: MSObjectType.contactperson,
                                     collectionName: "contactpersons")
        }
        
        dict["attributes"] = attributes?.flatMap { $0.value() }.map { $0.dictionary(metaOnly: false) }
        
        return dict
    }
}
