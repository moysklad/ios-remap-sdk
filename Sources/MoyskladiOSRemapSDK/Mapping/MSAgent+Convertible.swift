//
//  MSAgent+Convertible.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 28.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSAgent : DictConvertable {
	public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSAgent>? {
		guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
			return nil
		}
        
		guard let group = MSGroup.from(dict: dict.msValue("group")) else {
            return MSEntity.meta(meta)
		}
        
		return MSEntity.entity(MSAgent(meta: meta,
		        id: MSID(dict: dict),
		        accountId: dict.value("accountId") ?? "",
		        owner: MSEmployee.from(dict: dict.msValue("owner")),
		        shared: dict.value("shared") ?? false,
		        group: group,
		        info: MSInfo(dict: dict),
		        code: dict.value("code"),
		        externalCode: dict.value("externalCode"),
		        archived: dict.value("archived") ?? false,
		        actualAddress: dict.value("actualAddress"),
		        companyType: MSCompanyType(rawValue: dict.value("companyType") ?? "") ?? MSCompanyType.individual,
		        email: dict.value("email"),
		        phone: dict.value("phone"),
		        fax: dict.value("fax"),
		        legalTitle: dict.value("legalTitle"),
		        legalAddress: dict.value("legalAddress"),
		        inn: dict.value("inn"),
		        kpp: dict.value("kpp"),
		        ogrn: dict.value("ogrn"),
		        ogrnip: dict.value("ogrnip"),
		        okpo: dict.value("okpo"),
		        certificateNumber: dict.value("certificateNumber"),
		        certificateDate: Date.fromMSDate(dict.value("certificateDate") ?? ""),
		        accounts: dict.msValue("accounts").msArray("rows").map { MSAccount.from(dict: $0) }.compactMap { $0 },
		        agentInfo: MSAgentInfo.from(dict: dict),
                salesAmount: (dict.value("salesAmount") ?? 0.0).toMoney(),
                attributes: dict.msArray("attributes").map { MSAttribute.from(dict: $0) }.compactMap { $0 },
                report: nil
            ))
	}
}

extension MSAgentInfo {
	public func dictionary() -> Dictionary<String, Any> {
		return [String:Any]()
	}
	
	public static func from(dict: Dictionary<String, Any>) -> MSAgentInfo {
		return MSAgentInfo(isEgaisEnable: dict.value("isEgaisEnable"),
		                   fsrarId: dict.value("fsrarId"),
		                   payerVat: dict.value("payerVat") ?? false,
		                   utmUrl: dict.value("utmUrl"),
		                   director: dict.value("director"),
		                   chiefAccountant: dict.value("chiefAccountant"),
		                   tags: dict.value("tags") ?? [],
		                   contactpersons: dict.msValue("contactpersons").msArray("rows").map { MSContactPerson.from(dict: $0) }.compactMap { $0 },
                           discounts: dict.msArray("discounts").map { MSDiscount.from(dict: $0) }.compactMap { $0 },
		                   state: MSState.from(dict: dict.msValue("state")),
                           discountCardNumber: dict.value("discountCardNumber"),
                           priceType: dict.value("priceType"))
	}
}

extension MSDiscount {
    public func dictionary() -> Dictionary<String, Any> {
        return [String:Any]()
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSDiscount? {
        guard let meta = MSMeta.from(dict: dict.msValue("discount").msValue("meta"), parent: dict.msValue("discount")) else { return nil }
        
        return MSDiscount(meta: meta,
                          personalDiscount: dict.value("personalDiscount") ?? 0.0)
    }
}

extension MSContactPerson: DictConvertable {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        if meta.href.count > 0 {
            dict["meta"] = meta.dictionary()
        }
        
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        dict["email"] = email ?? ""
        dict["phone"] = phone ?? ""
        dict["position"] = position ?? ""
        
        return dict
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSContactPerson>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }
        
        guard let name: String = dict.value("name"), !name.isEmpty else {
            return MSEntity.meta(meta)
        }
        
        return MSEntity.entity(MSContactPerson(
            meta: meta,
            id: MSID(dict: dict),
            info: MSInfo(dict: dict),
            accountId: dict.value("accountId") ?? "",
            externalCode: dict.value("externalCode") ?? "",
            email: dict.value("email"),
            phone: dict.value("phone"),
            position: dict.value("position"),
            agent: nil
        ))
    }
}
