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
		             minPrice: (dict.value("minPrice") ?? 0.0).toMoney(),
		             buyPrice: MSPrice.from(dict: dict.msValue("buyPrice"), priceTypeOverride: LocalizedStrings.buyPrice.value),
		             salePrices: (dict["salePrices"] as? [Any] ?? []).map { MSPrice.from(dict: $0 as? Dictionary<String, Any> ?? [:]) }.compactMap { $0 },
		             supplier: MSAgent.from(dict: dict.msValue("supplier")),
		             country: MSCountry.from(dict: dict.msValue("country")),
		             article: dict.value("article"),
		             weighed: dict.value("weighed") ?? false,
		             weight: dict.value("weight") ?? 0,
		             volume: dict.value("volume") ?? 0,
                     barcodes: stringsToBarcodes(values: (dict.value("barcodes") ?? [])),
		             alcohol: MSAlcohol.from(dict: dict.msValue("alcoholic")),
		             modificationsCount: dict.value("modificationsCount"),
		             minimumBalance: dict.value("minimumBalance"),
		             isSerialTrackable: dict.value("isSerialTrackable") ?? false,
		             stock: dict.value("stock"),
		             reserve: dict.value("reserve"),
		             inTransit: dict.value("inTransit"),
		             quantity: dict.value("quantity"),
		             product: MSAssortment.from(dict: dict.msValue("product")),
		             attributes: dict.msArray("attributes").map { MSAttribute.from(dict: $0) }.compactMap { $0 },
		             packs: (dict["packs"] as? [Any] ?? []).map { MSPack.from(dict: $0 as? Dictionary<String, Any> ?? [:]) }.compactMap { $0 },
		             localImage: nil,
                     characteristics: dict.msArray("characteristics").map { MSVariantAttribute.from(dict: $0) }.compactMap { $0 },
                     components: dict.msValue("components").msArray("rows").map { MSBundleComponent.from(dict: $0) }.removeNils(),
                     overhead: MSBundleOverhead.from(dict: dict.msValue("overhead")),
                     assortment: MSAssortment.from(dict: dict.msValue("assortment"))))
	}
    
    public static func stringsToBarcodes(values: [String]) -> [MSBarcode] {
        return values.map({ return MSBarcode(value: $0, id: UUID().uuidString) })
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

extension MSVariantAttribute {
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSVariantAttribute>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }
        
        return MSEntity.entity(MSVariantAttribute(meta: meta,
                                                  id: MSID(dict: dict),
                                                  name: dict.value("name"),
                                                  value: dict.value("value"),
                                                  type: dict.value("type"),
                                                  required: dict.value("required") ?? false))
    }

}

extension MSProductFolder : DictConvertable {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        if meta.href.count > 0 {
            dict["meta"] = meta.dictionary()
        }
        
        return dict
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSProductFolder>? {
        guard dict.keys.count > 0 else {
            return nil
        }
        
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        guard let name: String = dict.value("name"), name.count > 0 else {
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
