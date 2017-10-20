//
//  Store+Convertible.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 26.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSStore : DictConvertable {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        
        dict["owner"] = serialize(entity: owner, metaOnly: metaOnly)
        dict["shared"] = shared
        dict["group"] = serialize(entity: group, metaOnly: metaOnly)
        dict["code"] = code ?? NSNull()
        dict["externalCode"] = externalCode ?? NSNull()
        dict["archived"] = archived
        dict["address"] = address ?? NSNull()
        dict["pathName"] = pathName ?? NSNull()
        
        return dict
    }
	
	public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSStore>? {
		guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
			return nil
		}
		
		guard let name: String = dict.value("name"), name.count > 0,
			let group = MSGroup.from(dict: dict.msValue("group")) else {
				return MSEntity.meta(meta)
		}
		
		
		return MSEntity.entity(MSStore(meta: meta,
		                               id: MSID(dict: dict),
		                               info: MSInfo(dict: dict),
		                               accountId: dict.value("accountId") ?? "",
		                               owner: MSEmployee.from(dict: dict.msValue("owner")),
		                               shared: dict.value("shared") ?? false,
		                               group: group,
		                               code: dict.value("code"),
		                               externalCode: dict.value("externalCode"),
		                               archived: dict.value("archived") ?? false,
		                               address: dict.value("adress"),
		                               parent: nil,
		                               pathName: dict.value("pathName")))
	}
}
