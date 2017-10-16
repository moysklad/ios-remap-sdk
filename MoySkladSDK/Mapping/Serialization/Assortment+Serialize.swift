//
//  Assortment+Serialize.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 16.10.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSAssortment {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        dict.merge(id.dictionary())
        
        dict["accountId"] = accountId
        dict["owner"] = serialize(entity: owner, metaOnly: true)
        dict["shared"] = shared
        dict["group"] = serialize(entity: group, metaOnly: true)
        dict["code"] = code ?? NSNull()
        dict["externalCode"] = externalCode ?? NSNull()
        dict["archived"] = archived
        dict["pathName"] = pathName ?? NSNull()
        dict["vat"] = vat ?? NSNull()
        dict["effectiveVat"] = effectiveVat ?? NSNull()
        dict["productFolder"] = serialize(entity: productFolder, metaOnly: true)
        dict["uom"] = serialize(entity: uom, metaOnly: true)
        dict["supplier"] = serialize(entity: supplier, metaOnly: true)
        dict["country"] = country?.dictionary() ?? NSNull()
        dict["article"] = article ?? NSNull()
        dict["weighed"] = weighed
        dict["weight"] = weight 
        dict["volume"] = volume
        dict["modificationsCount"] = modificationsCount ?? NSNull()
        dict["minimumBalance"] = minimumBalance ?? NSNull()
        dict["isSerialTrackable"] = isSerialTrackable
        dict["stock"] = stock ?? NSNull()
        dict["reserve"] = reserve ?? NSNull()
        dict["inTransit"] = inTransit ?? NSNull()
        dict["quantity"] = quantity ?? NSNull()
        dict["description"] = description ?? NSNull()
        dict["buyPrice"] = buyPrice?.dictionary() ?? NSNull()
        dict["alcohol"] = alcohol?.dictionary() ?? NSNull()
        dict["image"] = image?.dictionary() ?? NSNull()
        dict["salePrices"] = salePrices.map { $0.dictionary() }
        dict["assortmentInfo"] = assortmentInfo.dictionary()
        dict["barcodes"] = barcodes
        
        return dict
    }
}

extension MSPrice {
    public func dictionary() -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["priceType"] = priceType ?? NSNull()
        dict["value"] = value.minorUnits
        dict["currency"] = serialize(entity: currency, metaOnly: true)
        
        return dict
    }
}

extension MSAlcohol {
    public func dictionary() -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["excise"] = excise
        dict["type"] = type ?? NSNull()
        dict["strength"] = strength ?? NSNull()
        dict["volume"] = volume ?? NSNull()
        
        return dict
    }
}

extension MSAssortmentInfo {
    public func dictionary() -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["productFolder"] = serialize(entity: productFolder, metaOnly: true)
        dict["product"] = serialize(entity: product, metaOnly: true)
        dict["components"] = components.flatMap { $0.value() }.map { $0.dictionary(metaOnly: false) }
        
        return dict
    }
}

extension MSProduct {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        dict.merge(id.dictionary())
        
        dict["accountId"] = accountId
        dict["shared"] = shared
        dict["productFolder"] = serialize(entity: productFolder, metaOnly: true)
        dict["article"] = article ?? NSNull()
        dict["code"] = code ?? NSNull()
        dict["description"] = description ?? NSNull()
        dict["buyPrice"] = buyPrice?.dictionary() ?? NSNull()
        dict["supplier"] = serialize(entity: supplier, metaOnly: true)
        dict["image"] = image?.dictionary() ?? NSNull()
        dict["salePrices"] = salePrices.map { $0.dictionary() }
        
        return dict
    }
}

extension MSImage {
    public func dictionary() -> Dictionary<String, Any> {
        var dict = [String: Any]()
    
        dict["title"] = title
        dict["filename"] = filename
        dict["size"] = size
        dict["miniatureUrl"] = miniatureUrl.absoluteString
        dict["tinyUrl"] = tinyUrl?.absoluteString ?? NSNull()
        
        return dict
    }
}

extension MSBundleComponent {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        guard !metaOnly else { return dict }
        
        dict.merge(id.dictionary())
        
        dict["accountId"] = accountId
        dict["quantity"] = quantity
        dict["assortment"] = serialize(entity: assortment, metaOnly: true)
       
        return dict
    }
}
