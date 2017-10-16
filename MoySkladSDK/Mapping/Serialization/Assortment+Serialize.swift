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
        
//        dict.merge(info.dictionary())
        dict.merge(id.dictionary())
        
        dict["accountId"] = accountId
        dict["shared"] = shared
        
        if type(of: serialize(entity: group, metaOnly: false)) != type(of: NSNull()) {
            dict["group"] = serialize(entity: group, metaOnly: false)
        }
        
        if type(of: serialize(entity: owner, metaOnly: false)) != type(of: NSNull()) {
            dict["owner"] = serialize(entity: owner, metaOnly: false)
        }
        
        if type(of: serialize(entity: productFolder, metaOnly: false)) != type(of: NSNull()) {
            dict["productFolder"] = serialize(entity: productFolder, metaOnly: false)
        }
        
        if type(of: serialize(entity: supplier, metaOnly: false)) != type(of: NSNull()) {
            dict["supplier"] = serialize(entity: supplier, metaOnly: false)
        }
        
        if type(of: serialize(entity: uom, metaOnly: false)) != type(of: NSNull()) {
            dict["uom"] = serialize(entity: uom, metaOnly: false)
        }

        
        dict["code"] = code ?? ""
        dict["externalCode"] = externalCode ?? ""
        dict["archived"] = archived
        dict["pathName"] = pathName ?? ""
        dict["vat"] = vat ?? 0
        dict["effectiveVat"] = effectiveVat ?? 0
        dict["country"] = country?.dictionary() ?? NSNull()
        dict["article"] = article ?? ""
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
        dict["description"] = description ?? ""
        dict["buyPrice"] = buyPrice?.dictionary() ?? NSNull()
        dict["alcohol"] = alcohol?.dictionary() ?? NSNull()
        dict["image"] = image?.dictionary() ?? NSNull()
        dict["salePrices"] = salePrices.map { $0.dictionary() }
        dict["assortmentInfo"] = assortmentInfo.dictionary()
        dict["barcodes"] = barcodes
        
        return dict
    }
    
    public func requestUrl() -> MSApiRequest? {
        return MSApiRequest.product
    }
    
    public func deserializationError() -> MSError {
        return MSError.genericError(errorText: LocalizedStrings.incorrectProductResponse.value)
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
