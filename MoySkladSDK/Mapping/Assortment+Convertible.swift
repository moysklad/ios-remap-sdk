//
//  Assortment+Convertible.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 28.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation
//import Money

extension MSAssortment {
	public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSAssortment>? {
		guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
			return nil
		}

		return MSEntity.entity(MSAssortment(meta: meta,
		             id: MSID(dict: dict),
		             accountId: dict.value("accountId") ?? "",
		             owner: MSEmployee.from(dict: dict.msValue("owner")),
		             shared: dict.value("shared") ?? false,
		             group: MSGroup.from(dict: dict.msValue("group")),
		             info: MSInfo(dict: dict),
		             code: dict.value("code"),
		             externalCode: dict.value("externalCode"),
		             archived: dict.value("archived") ?? false,
		             pathName: dict.value("pathName"),
		             vat: dict.value("vat"),
		             effectiveVat: dict.value("effectiveVat"),
		             productFolder: MSProductFolder.from(dict: dict.msValue("productFolder")),
		             uom: MSUOM.from(dict: dict.msValue("uom")),
		             image: MSImage.from(dict: dict.msValue("image")),
		             buyPrice: MSPrice.from(dict: dict.msValue("buyPrice"), priceTypeOverride: "Цена закупки"), //LocalizedStrings.buyPrice.value),
		             salePrices: (dict["salePrices"] as? [Any] ?? []).map { MSPrice.from(dict: $0 as? Dictionary<String, Any> ?? [:]) }.flatMap { $0 },
		             supplier: MSAgent.from(dict: dict.msValue("supplier")),
		             country: nil,
		             article: dict.value("article"),
		             weighed: dict.value("weighed") ?? false,
		             weight: dict.value("weight") ?? 0,
		             volume: dict.value("volume") ?? 0,
		             barcodes: dict.value("barcodes") ?? [],
		             alcohol: MSAlcohol.from(dict: dict.msValue("alcoholic")),
		             modificationsCount: dict.value("modificationsCount"),
		             minimumBalance: dict.value("minimumBalance"),
		             isSerialTrackable: dict.value("isSerialTrackable") ?? false,
		             stock: dict.value("stock"),
		             reserve: dict.value("reserve"),
		             inTransit: dict.value("inTransit"),
		             quantity: dict.value("quantity"),
		             assortmentInfo: MSAssortmentInfo.from(dict: dict),
		             description: dict.value("description"),
		             attributes: dict.msArray("attributes").map { MSAttribute.from(dict: $0) }.flatMap { $0 }))
	}
}

extension MSAlcohol {
	public static func from(dict: Dictionary<String, Any>) -> MSAlcohol? {
		guard dict.keys.count > 0 else {
			return nil
		}
		
		return MSAlcohol(excise: dict.value("excise") ?? false, type: dict.value("type"), strength: dict.value("strength"), volume: dict.value("volume"))
	}
}

extension MSProduct {
    public func dictionary() -> Dictionary<String, Any> {
        return [String:Any]()
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSProduct>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        return MSEntity.entity(MSProduct(meta: meta,
                  id: MSID(dict: dict),
                  accountId: dict.value("accountId") ?? "",
                  shared: dict.value("shared") ?? false,
                  info: MSInfo(dict: dict),
                  productFolder: MSProductFolder.from(dict: dict.msValue("productFolder")),
                  article: dict.value("article"),
                  code: dict.value("code"),
                  description: dict.value("description"),
                  image: MSImage.from(dict: dict.msValue("image")),
                  buyPrice: MSPrice.from(dict: dict.msValue("buyPrice"), priceTypeOverride: "Цена закупки"),//LocalizedStrings.buyPrice.value),
                  salePrices: (dict["salePrices"] as? [Any] ?? []).map { MSPrice.from(dict: $0 as? Dictionary<String, Any> ?? [:]) }.removeNils(),
                  supplier: MSAgent.from(dict: dict.msValue("supplier"))))
    }
}

extension MSAssortmentInfo {
    public static func from(dict: Dictionary<String, Any>) -> MSAssortmentInfo {
        return MSAssortmentInfo(productFolder: MSProductFolder.from(dict: dict.msValue("productFolder")),
                                product: MSProduct.from(dict: dict.msValue("product")),
                                components: dict.msValue("components").msArray("rows").map { MSBundleComponent.from(dict: $0) }.removeNils())
    }
}

extension MSProductFolder : DictConvertable {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        return [String:Any]()
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSProductFolder>? {
        guard dict.keys.count > 0 else {
            return nil
        }
        
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        guard let name: String = dict.value("name"), name.characters.count > 0 else {
            return MSEntity.meta(meta)
        }
        
        return MSEntity.entity(MSProductFolder(meta: meta,
                                               id: MSID(dict: dict),
                                               accountId: dict.value("accountId") ?? "",
                                               shared: dict.value("shared") ?? false,
                                               info: MSInfo(dict: dict),
                                               externalCode: dict.value("externalCode") ?? "",
                                               pathName: dict.value("pathName")))
    }
}
