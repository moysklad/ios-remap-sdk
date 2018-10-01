//
//  MSContract+Convertible.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 27.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

//import Money
import Foundation

extension MSContract : DictConvertable {	
	public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSContract>? {
		guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
			return nil
		}
		
		guard let name: String = dict.value("name"), name.count > 0,
			let group = MSGroup.from(dict: dict.msValue("group")) else {
				return MSEntity.meta(meta)
		}
		        
		return MSEntity.entity(MSContract(meta: meta,
		           id: MSID(dict: dict),
		           info: MSInfo(dict: dict),
		           accountId: dict.value("accountId") ?? "",
		           owner: MSEmployee.from(dict: dict.msValue("owner")),
		           shared: dict.value("shared") ?? false,
		           group: group,
		           code: dict.value("code"),
		           externalCode: dict.value("externalCode"),
		           archived: dict.value("archived") ?? false,
		           moment: Date.fromMSDate(dict.value("moment") ?? ""),
		           sum: (dict.value("sum") ?? 0.0).toMoney(),
		           contractType: MSContractType(rawValue: dict.value("contractType") ?? ""),
		           rewardType: MSRewardType(rawValue: dict.value("rewardType") ?? ""),
		           rewardPercent: dict.value("rewardPercent"),
		           ownAgent: MSAgent.from(dict: dict.msValue("ownAgent")),
		           agent: MSAgent.from(dict: dict.msValue("agent")),
		           state: MSState.from(dict: dict.msValue("state")),
		           organizationAccount: MSAccount.from(dict: dict.msValue("organizationAccount")),
		           agentAccount: MSAccount.from(dict: dict.msValue("agentAccount")),
		           rate: MSRate.from(dict: dict.msValue("rate")),
                   attributes: dict.msArray("attributes").map { MSAttribute.from(dict: $0) }.compactMap { $0 }))
	}
}

extension MSAccount : DictConvertable {
	public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        if meta.href.count > 0 {
            dict["meta"] = meta.dictionary()
        }
        
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        dict["isDefault"] = isDefault
        dict["accountNumber"] = accountNumber
        dict["bankName"] = bankName ?? ""
        dict["bankLocation"] = bankLocation ?? ""
        dict["correspondentAccount"] = correspondentAccount ?? ""
        dict["bic"] = bic ?? ""
        
        return dict
	}
	
	public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSAccount>? {
		guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
			return nil
		}
		
		guard let accountNumber: String = dict.value("accountNumber"), accountNumber.count > 0 else {
				return MSEntity.meta(meta)
		}
		
		return MSEntity.entity(MSAccount(meta: meta,
		          id: MSID(dict: dict),
		          info: MSInfo(dict: dict),
		          accountId: dict.value("accountId") ?? "",
		          isDefault: dict.value("isDefault") ?? false,
		          accountNumber: accountNumber,
		          bankName: dict.value("bankName"),
		          bankLocation: dict.value("bankLocation"),
		          correspondentAccount: dict.value("correspondentAccount"),
		          bic: dict.value("bic"),
		          agent: nil))
	}
}
